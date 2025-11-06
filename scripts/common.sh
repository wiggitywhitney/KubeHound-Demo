#!/bin/bash
# scripts/common.sh - Shared logging and utility functions

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
}

wait_for_pods_ready() {
    local timeout=${1:-300}
    local interval=${2:-15}
    local elapsed=0

    log_step "⏳ Waiting for Pods to be Ready"
    log_info "Timeout: ${timeout}s, checking every ${interval}s"
    sleep 5  # Give pods time to start

    while [ $elapsed -lt $timeout ]; do
        local total=$(kubectl get pods --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
        local running=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')

        if [ "$total" -eq 0 ]; then
            log_info "No pods found yet (${elapsed}s elapsed)"
        elif [ "$running" -eq "$total" ]; then
            log_success "All $total pods are running"
            return 0
        else
            log_info "Progress: $running/$total pods running (${elapsed}s elapsed)"
        fi

        sleep $interval
        elapsed=$((elapsed + interval))
    done

    log_error "Timeout after ${timeout}s"
    kubectl get pods --all-namespaces
    return 1
}
