#!/bin/bash

#######################################################################
# teardown-kubehound-test-cluster.sh - Cleanup KubeHound Test Cluster
#
# Removes the KubeHound test cluster and associated resources
#
# Usage: ./teardown-kubehound-test-cluster.sh
#######################################################################

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
CLUSTER_NAME="kubehound-test-local"
KUBECONFIG_FILE="./kubehound-test.kubeconfig"

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_step() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
}

main() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   KubeHound Test Cluster Teardown                ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    log_step "🗑️  Deleting Kind Cluster"

    if ! kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
        log_info "Cluster '$CLUSTER_NAME' not found, nothing to clean up"
    else
        log_info "Deleting cluster '$CLUSTER_NAME'..."
        kind delete cluster --name "$CLUSTER_NAME"
        log_success "Cluster deleted"
    fi

    log_step "🧹 Cleaning Up Files"

    if [ -f "$KUBECONFIG_FILE" ]; then
        rm -f "$KUBECONFIG_FILE"
        log_success "Removed kubeconfig file"
    fi

    if [ -d "./dump-test" ]; then
        rm -rf ./dump-test
        log_success "Removed dump directory"
    fi

    echo ""
    echo -e "${GREEN}✅ Cleanup complete!${NC}"
    echo ""
    log_info "KubeHound backend is still running (shared with Goat setup)"
    log_info "To stop backend: kubehound backend down"
    echo ""
}

main
