#!/bin/bash
# ABOUTME: Sets up a Kind cluster with intentional misconfigurations for KubeHound demo
# ABOUTME: Creates cluster, deploys attack scenarios, starts backend, dumps and ingests data

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

check_prerequisites() {
    local missing_tools=()
    local os_type
    os_type=$(uname -s)

    # Check Docker
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    elif ! docker info &> /dev/null; then
        log_error "Docker is installed but not running"
        if [[ "$os_type" == "Darwin" ]] || [[ "$os_type" == "MINGW"* ]] || [[ "$os_type" == "MSYS"* ]]; then
            log_info "Start Docker Desktop and try again"
        else
            log_info "Start Docker daemon: sudo systemctl start docker"
        fi
        exit 1
    fi

    # Check Kind
    if ! command -v kind &> /dev/null; then
        missing_tools+=("kind")
    fi

    # Check kubectl
    if ! command -v kubectl &> /dev/null; then
        missing_tools+=("kubectl")
    fi

    # Check KubeHound CLI
    if ! command -v kubehound &> /dev/null; then
        missing_tools+=("kubehound")
    fi

    # Verify KubeHound minimum version (tested with v1.6.4+)
    if command -v kubehound &> /dev/null; then
        local kh_version
        kh_version=$(kubehound version 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' || echo "")
        if [[ -n "$kh_version" ]]; then
            local kh_major kh_minor kh_patch
            kh_major=$(echo "$kh_version" | sed 's/v//' | cut -d. -f1)
            kh_minor=$(echo "$kh_version" | cut -d. -f2)
            kh_patch=$(echo "$kh_version" | cut -d. -f3)
            # Minimum version: v1.6.4 (added MITRE ATT&CK TTP mapping)
            if [[ "$kh_major" -lt 1 ]] || [[ "$kh_major" -eq 1 && "$kh_minor" -lt 6 ]] || \
               [[ "$kh_major" -eq 1 && "$kh_minor" -eq 6 && "$kh_patch" -lt 4 ]]; then
                log_warning "KubeHound $kh_version detected — this demo was tested with v1.6.4+"
                log_info "Some features may not work. Upgrade: brew upgrade kubehound"
            else
                log_info "KubeHound $kh_version detected"
            fi
        fi
    fi

    # If any tools are missing, show installation guidance
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        echo ""
        echo "Please install the missing tools:"
        echo ""

        for tool in "${missing_tools[@]}"; do
            case $tool in
                docker)
                    echo "  Docker: https://docs.docker.com/get-docker/"
                    ;;
                kind)
                    echo "  Kind: https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
                    if [[ "$os_type" == "Darwin" ]]; then
                        echo "    (macOS: brew install kind)"
                    fi
                    ;;
                kubectl)
                    echo "  kubectl: https://kubernetes.io/docs/tasks/tools/"
                    if [[ "$os_type" == "Darwin" ]]; then
                        echo "    (macOS: brew install kubectl)"
                    fi
                    ;;
                kubehound)
                    echo "  KubeHound CLI: https://kubehound.io/user-guide/getting-started/"
                    if [[ "$os_type" == "Darwin" ]]; then
                        echo "    (macOS: brew install kubehound)"
                    fi
                    ;;
            esac
        done
        echo ""
        exit 1
    fi
}

main() {
    local start_time=$(date +%s)
    local REPO_ROOT="$(pwd)"

    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   KubeHound Test Cluster Setup (Evaluation)      ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""

    log_step "✅ Checking Prerequisites"
    check_prerequisites
    log_success "All required tools are installed"

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

    if [ -n "$(docker ps --filter "name=kubehound-release" --quiet)" ]; then
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

    # Clean up Jupyter UI: Remove all notebooks except KindCluster_Demo.ipynb
    # This is non-critical - if it fails, the demo still works
    log_info "Cleaning up Jupyter notebook interface..."
    if docker exec kubehound-release-ui-jupyter-1 bash -c \
        'cd /kubehound/notebooks/kubehound_presets && find . -maxdepth 1 -name "*.ipynb" ! -name "KindCluster_Demo.ipynb" -delete' 2>/dev/null; then
        log_success "Jupyter UI cleaned - only demo notebook visible"
    else
        log_info "Note: Could not clean Jupyter UI (non-critical - demo will still work)"
    fi

    log_step "📥 Collecting Cluster State"

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
    echo -e "${BLUE}🎯 What You Got:${NC}"
    echo -e "   • KubeHound running locally (backend + Jupyter Notebook UI)"
    echo -e "   • 3-node Kubernetes cluster ($CLUSTER_NAME) with intentional misconfigurations"
    echo -e "   • Pre-built attack graph ready to explore in the notebook"
    echo ""
    echo -e "${BLUE}📋 Next Steps:${NC}"
    echo -e "   1. Open the Jupyter Notebook UI at http://localhost:8888"
    echo -e "   2. Enter password 'admin' and click Login"
    echo -e "   3. Navigate to kubehound_presets/"
    echo -e "   4. Open KindCluster_Demo.ipynb (the guided attack path walkthrough)"
    echo -e "   5. Follow the notebook instructions"
    echo ""
    echo -e "${BLUE}🧹 Cleanup:${NC} ./teardown-kubehound-test-cluster.sh"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""
    log_success "Setup completed in ${minutes}m ${seconds}s"
    echo ""
}

main
