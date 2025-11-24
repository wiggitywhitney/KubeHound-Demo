#!/bin/bash

#######################################################################
# setup-kubehound-test-cluster.sh - KubeHound Test Cluster Setup
#
# This script deploys KubeHound's official test cluster with the
# ENDPOINT_EXPLOIT attack scenario designed for KubeHound.
#
# Purpose: Demonstrate KubeHound attack path discovery with an
# educational Jupyter notebook that shows progressive filtering
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
KUBECONFIG_FILE="./kubehound-test.kubeconfig"

main() {
    local start_time=$(date +%s)
    local REPO_ROOT="$(pwd)"

    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   KubeHound Test Cluster Setup (Evaluation)      ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    log_step "🏗️  Creating Kind Cluster: $CLUSTER_NAME"

    if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_error "Cluster '$CLUSTER_NAME' already exists!"
        log_info "Run './teardown-kubehound-test-cluster.sh' first"
        exit 1
    fi

    log_info "Creating 3-node cluster with Kind..."
    kind create cluster \
        --name "$CLUSTER_NAME" \
        --config "$SCRIPT_DIR/cluster-config/kind-cluster.yaml" \
        --wait 2m

    # Verify cluster was created
    if ! kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_error "Cluster creation failed"
        exit 1
    fi

    # Export kubeconfig
    kind get kubeconfig --name "$CLUSTER_NAME" > "$REPO_ROOT/$KUBECONFIG_FILE"
    export KUBECONFIG="$REPO_ROOT/$KUBECONFIG_FILE"

    log_success "Cluster created successfully"

    log_step "🎯 Deploying Attack Scenarios"

    log_info "Creating required namespaces..."
    kubectl create namespace vault --dry-run=client -o yaml | kubectl apply -f - > /dev/null 2>&1
    kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f - > /dev/null 2>&1

    log_info "Applying 1 vulnerable resource manifest (ENDPOINT_EXPLOIT)..."
    kubectl apply -f "$SCRIPT_DIR/attacks/ENDPOINT_EXPLOIT.yaml" > /dev/null 2>&1

    log_success "Attack scenarios deployed"

    wait_for_pods_ready 120 10

    log_step "🔧 Starting KubeHound Backend"

    log_info "Checking backend health..."

    if ! command -v docker &> /dev/null; then
        log_error "Docker not found. Please install Docker and try again."
        exit 1
    elif ! docker info &> /dev/null; then
        log_error "Docker daemon not running. Please start Docker and try again."
        exit 1
    elif [ -n "$(docker ps --filter "name=kubehound-release" --quiet)" ]; then
        log_success "KubeHound backend is running"
    else
        log_info "Starting backend..."
        kubehound backend up
        sleep 10
        log_success "Backend started"
    fi

    # Apply v2 notebook if available
    if [ -f "$REPO_ROOT/KindCluster_Demo_v2.ipynb" ]; then
        docker cp "$REPO_ROOT/KindCluster_Demo_v2.ipynb" kubehound-release-ui-jupyter-1:/kubehound/notebooks/kubehound_presets/KindCluster_Demo.ipynb 2>/dev/null
    fi

    log_step "📥 Collecting Cluster State"

    # Return to repo root for ingestion
    cd - > /dev/null

    log_info "KubeHound is collecting cluster configuration (aka 'dump')..."
    log_info "Gathering pods, roles, bindings, volumes, and other resources"
    rm -rf ./dump-test
    export KUBECONFIG="$REPO_ROOT/$KUBECONFIG_FILE"
    echo ""
    log_command "kubehound dump local ./dump-test -y"
    kubehound dump local ./dump-test -y

    log_info "KubeHound is extracting the collected data from tar archive..."
    cd dump-test/kind-kubehound.test.local

    archive_count=$(ls -1 kubehound_kind-kubehound.test.local_*.tar.gz 2>/dev/null | wc -l)
    if [ "$archive_count" -ne 1 ]; then
        log_error "Expected 1 archive, found $archive_count"
        exit 1
    fi

    tar -xzf kubehound_kind-kubehound.test.local_*.tar.gz
    cd "$REPO_ROOT"

    log_step "🔗 Building Attack Graph"

    log_info "KubeHound is ingesting the collected data (aka 'ingest')..."
    log_info "Analyzing relationships and discovering attack paths"
    echo ""
    log_command "kubehound ingest local dump-test/kind-kubehound.test.local --skip-backend"
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
    echo -e "   • 1 attack scenario (ENDPOINT_EXPLOIT) designed for KubeHound"
    echo -e "   • 3-node Kind cluster: $CLUSTER_NAME"
    echo -e "   • Attack graph with multiple attack paths"
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
