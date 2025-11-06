#!/bin/bash

#######################################################################
# setup-kubehound-test-cluster.sh - KubeHound Test Cluster Setup
#
# This script deploys KubeHound's official test cluster with 24
# pre-built attack scenarios specifically designed for KubeHound.
#
# Purpose: Validate that KubeHound graph queries work correctly
# Compare with Kubernetes Goat to determine best demo approach
#
# Usage: ./setup-kubehound-test-cluster.sh
# Cleanup: ./teardown-kubehound-test-cluster.sh
#######################################################################

set -euo pipefail

# Source shared logging functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# Configuration
CLUSTER_NAME="kubehound.test.local"
KUBEHOUND_REPO="/tmp/kubehound-repo"
KUBECONFIG_FILE="./kubehound-test.kubeconfig"

main() {
    local start_time=$(date +%s)
    local REPO_ROOT="$(pwd)"

    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   KubeHound Test Cluster Setup (Evaluation)      ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    log_step "📦 Checking KubeHound Repository"

    if [ ! -d "$KUBEHOUND_REPO" ]; then
        log_info "Cloning KubeHound repository..."
        git clone --depth 1 https://github.com/DataDog/KubeHound.git "$KUBEHOUND_REPO"
        log_success "Repository cloned"
    else
        log_success "Repository already exists at $KUBEHOUND_REPO"
    fi

    log_step "🏗️  Creating Kind Cluster: $CLUSTER_NAME"

    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_error "Cluster '$CLUSTER_NAME' already exists!"
        log_info "Run './teardown-kubehound-test-cluster.sh' first"
        exit 1
    fi

    cd "$KUBEHOUND_REPO/test/setup"

    log_info "Creating cluster with 24 attack scenarios..."
    # Note: manage-cluster.sh has a kubeconfig bug but cluster creation succeeds
    CLUSTER_NAME="$CLUSTER_NAME" bash manage-cluster.sh create || true

    # Verify cluster was actually created despite the error
    if ! kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_error "Cluster creation failed!"
        exit 1
    fi

    # Export kubeconfig (working around KubeHound's script bug)
    kind get kubeconfig --name "$CLUSTER_NAME" > "$REPO_ROOT/$KUBECONFIG_FILE"
    export KUBECONFIG="$REPO_ROOT/$KUBECONFIG_FILE"

    log_success "Cluster created (worked around KubeHound kubeconfig bug)"

    log_step "🎯 Deploying Attack Scenarios"

    log_info "Creating required namespaces..."
    kubectl create namespace vault --dry-run=client -o yaml | kubectl apply -f - > /dev/null 2>&1
    kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f - > /dev/null 2>&1

    log_info "Applying 24 vulnerable resource manifests..."
    # Deploy attack scenarios directly (bypassing buggy script)
    for attack in "$KUBEHOUND_REPO/test/setup/test-cluster/attacks"/*.yaml; do
        kubectl apply -f "$attack" > /dev/null 2>&1
    done

    log_success "Attack scenarios deployed"

    log_step "⏳ Waiting for Pods to be Ready"

    log_info "Waiting for all pods to reach Running state..."
    sleep 10

    local timeout=120
    local elapsed=0
    while [ $elapsed -lt $timeout ]; do
        local total=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
        local running=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')

        if [ "$total" -eq 0 ]; then
            log_info "No pods found yet, waiting..."
        elif [ "$running" -eq "$total" ]; then
            log_success "All $total pods are running"
            break
        else
            log_info "Progress: $running/$total pods running (${elapsed}s elapsed)"
        fi

        sleep 10
        elapsed=$((elapsed + 10))
    done

    log_step "🔧 Starting KubeHound Backend"

    log_info "Checking backend health..."

    if docker ps | grep -q "kubehound-release"; then
        log_success "KubeHound backend is running"
    else
        log_info "Starting backend..."
        kubehound backend up
        sleep 10
        log_success "Backend started"
    fi

    log_step "📥 Dumping Cluster Data"

    # Return to repo root for ingestion
    cd - > /dev/null

    log_info "Running: kubehound dump local ./dump-test -y"
    log_info "Collects cluster data (pods, roles, bindings, volumes, etc.)"
    rm -rf ./dump-test
    export KUBECONFIG="$REPO_ROOT/$KUBECONFIG_FILE"
    kubehound dump local ./dump-test -y

    log_info "Extracting dump archive..."
    cd dump-test/kind-kubehound.test.local

    archive_count=$(ls -1 kubehound_kind-kubehound.test.local_*.tar.gz 2>/dev/null | wc -l)
    if [ "$archive_count" -ne 1 ]; then
        log_error "Expected 1 archive, found $archive_count"
        exit 1
    fi

    tar -xzf kubehound_kind-kubehound.test.local_*.tar.gz
    cd "$REPO_ROOT"

    log_step "🔗 Building Attack Graph"

    log_info "Running: kubehound ingest local dump-test/kind-kubehound.test.local"
    log_info "Analyzes relationships and discovers attack paths"
    kubehound ingest local dump-test/kind-kubehound.test.local --skip-backend

    log_success "Attack graph built and ready to explore!"

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ KubeHound Test Cluster Ready!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}🌐 KubeHound UI:${NC} http://localhost:8888"
    echo -e "   ${YELLOW}Password:${NC} admin"
    echo ""
    echo -e "${BLUE}🎯 What You Got:${NC}"
    echo -e "   • 24 attack scenarios purpose-built for KubeHound"
    echo -e "   • 3-node Kind cluster: $CLUSTER_NAME"
    echo -e "   • Attack graph with multiple attack types"
    echo ""
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo -e "   1. Open http://localhost:8888"
    echo -e "   2. Navigate to kubehound_presets/"
    echo -e "   3. Open KindCluster_Demo.ipynb"
    echo -e "   4. Run cells to explore attack paths"
    echo ""
    echo -e "${BLUE}🧹 Cleanup:${NC} ./teardown-kubehound-test-cluster.sh"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""
    log_success "Setup completed in ${minutes}m ${seconds}s"
    echo ""
}

main
