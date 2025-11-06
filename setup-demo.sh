#!/bin/bash

#######################################################################
# setup-demo.sh - Automated KubeHound Demo Environment Setup
#
# Creates a complete KubeHound demo environment with:
# - Kind cluster running Kubernetes Goat (vulnerable scenarios)
# - KubeHound backend (JanusGraph, MongoDB, UI)
#
# This script wraps the community-maintained Kubernetes Goat setup
# and adds KubeHound integration for attack path analysis demos.
#
# Usage: ./setup-demo.sh
# Cleanup: ./teardown-demo.sh
#
# Credit: Uses official Kubernetes Goat setup from:
# https://github.com/madhuakula/kubernetes-goat
#######################################################################

set -euo pipefail

# Source shared logging functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# Configuration
CLUSTER_NAME="kubernetes-goat-cluster"
GOAT_REPO_DIR="./kubernetes-goat"
GOAT_REPO_URL="https://github.com/madhuakula/kubernetes-goat.git"
POD_READY_TIMEOUT=300  # 5 minutes
POD_CHECK_INTERVAL=15   # Check every 15 seconds

#######################################################################
# Prerequisite Checks
#######################################################################

check_prerequisites() {
    log_step "🔍 Checking Prerequisites"

    local missing_deps=()

    # Check Docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    else
        log_success "Docker installed: $(docker --version | head -n1)"

        # Check Docker is running
        if ! docker info &> /dev/null; then
            log_error "Docker daemon is not running. Please start Docker and try again."
            exit 1
        fi
        log_success "Docker daemon is running"
    fi

    # Check Kind
    if ! command -v kind &> /dev/null; then
        missing_deps+=("kind")
    else
        log_success "Kind installed: $(kind version | head -n1)"
    fi

    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        missing_deps+=("kubectl")
    else
        log_success "kubectl installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>&1 | head -n1)"
    fi

    # Check Helm
    if ! command -v helm &> /dev/null; then
        missing_deps+=("helm")
    else
        log_success "Helm installed: $(helm version --short)"
    fi

    # Check KubeHound
    if ! command -v kubehound &> /dev/null; then
        missing_deps+=("kubehound")
    else
        log_success "KubeHound installed: $(kubehound version 2>/dev/null || echo 'version check not supported')"
    fi

    # Check git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    else
        log_success "git installed: $(git --version)"
    fi

    # Report missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Installation guides:"
        echo "  - Docker:     https://docs.docker.com/get-docker/"
        echo "  - Kind:       https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
        echo "  - kubectl:    https://kubernetes.io/docs/tasks/tools/"
        echo "  - Helm:       https://helm.sh/docs/intro/install/"
        echo "  - KubeHound:  https://kubehound.io/getting-started/installation/"
        echo "  - git:        https://git-scm.com/downloads"
        exit 1
    fi

    log_success "All prerequisites satisfied!"
}

#######################################################################
# Kubernetes Goat Setup
#######################################################################

setup_kubernetes_goat() {
    log_step "🐐 Setting Up Kubernetes Goat"

    # Clone or update Kubernetes Goat repository
    if [ -d "$GOAT_REPO_DIR" ]; then
        log_info "Kubernetes Goat repository already exists at $GOAT_REPO_DIR"
        log_info "Using existing repository (run 'git pull' inside if you want latest version)"
    else
        log_info "Cloning Kubernetes Goat repository..."
        git clone "$GOAT_REPO_URL" "$GOAT_REPO_DIR"
        log_success "Repository cloned to $GOAT_REPO_DIR"
    fi

    # Check if cluster already exists
    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_error "Cluster '$CLUSTER_NAME' already exists!"
        log_info "Please run './teardown-demo.sh' first to clean up, then try again."
        exit 1
    fi

    # Run Kubernetes Goat's official Kind setup script
    log_info "Running Kubernetes Goat's official setup script..."
    log_info "This will create Kind cluster and deploy all vulnerable scenarios..."
    echo ""

    cd "$GOAT_REPO_DIR/platforms/kind-setup"

    # Run their script
    bash setup-kind-cluster-and-goat.sh

    # Return to original directory
    cd - > /dev/null

    echo ""
    log_success "Kubernetes Goat deployed successfully"
}

#######################################################################
# Wait for Pods Ready
#######################################################################

wait_for_pods_ready() {
    log_step "⏳ Waiting for Pods to be Ready"

    log_info "Timeout: ${POD_READY_TIMEOUT}s, checking every ${POD_CHECK_INTERVAL}s"
    log_info "This ensures all Kubernetes Goat scenarios are fully deployed..."

    local elapsed=0
    local all_ready=false

    # Give pods a moment to start appearing
    sleep 5

    while [ $elapsed -lt $POD_READY_TIMEOUT ]; do
        # Get pod counts
        local total_pods=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
        local running_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')

        # Count ready pods (have Ready condition = True)
        local ready_pods=0
        if command -v jq &> /dev/null; then
            ready_pods=$(kubectl get pods --all-namespaces -o json 2>/dev/null | jq -r '.items[] | select(.status.conditions[]? | select(.type=="Ready" and .status=="True")) | .metadata.name' 2>/dev/null | wc -l | tr -d ' ')
        else
            # Fallback if jq not available: assume Running = Ready
            ready_pods=$running_pods
        fi

        # Handle case where no pods exist yet
        if [ "$total_pods" -eq 0 ]; then
            log_warning "No pods found yet, waiting... (${elapsed}s elapsed)"
            sleep $POD_CHECK_INTERVAL
            elapsed=$((elapsed + POD_CHECK_INTERVAL))
            continue
        fi

        log_info "Progress: $ready_pods/$total_pods pods ready, $running_pods running (${elapsed}s elapsed)"

        # Check if all pods are ready (allow for some tolerance)
        # Consider it ready if running pods == total pods (simple check)
        if [ "$running_pods" -eq "$total_pods" ] && [ "$total_pods" -gt 0 ]; then
            all_ready=true
            break
        fi

        sleep $POD_CHECK_INTERVAL
        elapsed=$((elapsed + POD_CHECK_INTERVAL))
    done

    if [ "$all_ready" = true ]; then
        log_success "All pods are ready! (took ${elapsed}s)"
    else
        log_error "Timeout waiting for pods to be ready after ${POD_READY_TIMEOUT}s"
        log_info "Current pod status:"
        kubectl get pods --all-namespaces
        log_warning "Some pods may still be starting. You can continue, but demo may not work correctly."
        log_info "Check status with: kubectl get pods --all-namespaces"
        exit 1
    fi
}

#######################################################################
# KubeHound Backend Setup
#######################################################################

start_kubehound_backend() {
    log_step "🔧 Starting KubeHound Backend"

    log_info "Starting MongoDB, JanusGraph, and Jupyter UI..."

    # Start backend (this runs docker-compose)
    kubehound backend up

    log_info "Waiting for backend services to be healthy (15s)..."
    sleep 15

    log_success "KubeHound backend started"
}

#######################################################################
# Health Verification
#######################################################################

verify_health() {
    log_step "🏥 Verifying Environment Health"

    # Check kubectl context
    log_info "Kubernetes cluster info:"
    kubectl cluster-info --context "kind-${CLUSTER_NAME}" 2>/dev/null || kubectl cluster-info

    # Check pod status summary
    local total_pods=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
    local running_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')

    log_success "$running_pods/$total_pods pods are in Running state"

    # Show any non-running pods
    local non_running=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')
    if [ "$non_running" -gt 0 ]; then
        log_warning "$non_running pods are not Running:"
        kubectl get pods --all-namespaces --field-selector=status.phase!=Running
    fi

    # Check KubeHound UI accessibility
    log_info "Checking KubeHound UI accessibility..."
    sleep 2
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:8888 2>/dev/null | grep -qE "200|302|403"; then
        log_success "KubeHound UI is accessible at http://localhost:8888"
    else
        log_warning "KubeHound UI not accessible yet (may still be starting)"
        log_info "Try accessing http://localhost:8888 in a few moments"
    fi
}

#######################################################################
# Success Summary
#######################################################################

print_success_summary() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Demo Environment Ready!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}🌐 KubeHound UI:${NC} http://localhost:8888"
    echo -e "   ${YELLOW}Password:${NC} admin"
    echo ""
    echo -e "${BLUE}🐐 Kubernetes Goat:${NC} Deployed with 20+ vulnerable scenarios"
    echo -e "   ${YELLOW}Cluster:${NC} kind-${CLUSTER_NAME}"
    echo ""
    echo -e "${BLUE}📋 Next Steps (MANUAL - this is the demo!):${NC}"
    echo ""
    echo -e "   ${YELLOW}1.${NC} kubehound dump"
    echo -e "      ${BLUE}↳${NC} Collect Kubernetes cluster data"
    echo ""
    echo -e "   ${YELLOW}2.${NC} kubehound ingest"
    echo -e "      ${BLUE}↳${NC} Analyze data and build attack graph"
    echo ""
    echo -e "   ${YELLOW}3.${NC} Open http://localhost:8888"
    echo -e "      ${BLUE}↳${NC} Explore discovered attack paths in UI"
    echo ""
    echo -e "${BLUE}🧹 Cleanup:${NC} ./teardown-demo.sh"
    echo ""
    echo -e "${BLUE}💡 Tips:${NC}"
    echo -e "   • Verify cluster: ${YELLOW}kubectl get pods --all-namespaces${NC}"
    echo -e "   • Check contexts: ${YELLOW}kubectl config get-contexts${NC}"
    echo -e "   • Goat scenarios: ${YELLOW}https://madhuakula.com/kubernetes-goat/${NC}"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
}

#######################################################################
# Main Execution
#######################################################################

main() {
    local start_time=$(date +%s)

    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     KubeHound Demo Environment Setup             ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    check_prerequisites
    setup_kubernetes_goat
    wait_for_pods_ready
    start_kubehound_backend
    verify_health

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    print_success_summary

    echo ""
    log_success "Setup completed in ${minutes}m ${seconds}s"
    echo ""
}

# Run main function
main
