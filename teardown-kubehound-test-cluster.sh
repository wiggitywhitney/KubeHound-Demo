#!/bin/bash

#######################################################################
# teardown-kubehound-test-cluster.sh - Cleanup KubeHound Test Cluster
#
# Removes the KubeHound test cluster and associated resources
#
# Usage: ./teardown-kubehound-test-cluster.sh
#######################################################################

set -euo pipefail

# Source shared logging functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# Configuration
CLUSTER_NAME="kubehound.test.local"
KUBECONFIG_FILE="./kubehound-test.kubeconfig"

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

    log_step "🛑 Stopping KubeHound Backend"

    if ! command -v docker &> /dev/null; then
        log_warning "Docker not found, skipping backend stop"
    elif ! docker info &> /dev/null; then
        log_warning "Docker daemon not running, skipping backend stop"
    elif [ -n "$(docker ps --filter "name=kubehound-release" --quiet)" ]; then
        log_info "Stopping backend containers..."
        kubehound backend down
        log_success "Backend stopped"
    else
        log_info "Backend not running, nothing to stop"
    fi

    echo ""
    echo -e "${GREEN}✅ Cleanup complete!${NC}"
    echo ""
}

main
