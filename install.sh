#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Claude Code Server Installer v1.0        ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ -f /etc/redhat-release ]; then
        OS="centos"
    else
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    fi
    echo -e "${GREEN}[✓]${NC} Detected OS: $OS"
}

# Check if running as root or with sudo
check_permissions() {
    if [ "$EUID" -ne 0 ] && ! sudo -n true 2>/dev/null; then
        echo -e "${YELLOW}[!]${NC} This script may need sudo permissions for some operations."
    fi
}

# Install Node.js using NodeSource or nvm
install_nodejs() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo -e "${GREEN}[✓]${NC} Node.js already installed: $NODE_VERSION"
        return 0
    fi

    echo -e "${YELLOW}[*]${NC} Installing Node.js..."

    case $OS in
        ubuntu|debian)
            # Use NodeSource for Ubuntu/Debian
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
            ;;
        centos|rhel|fedora|rocky|almalinux)
            # Use NodeSource for RHEL-based
            curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
            sudo yum install -y nodejs || sudo dnf install -y nodejs
            ;;
        alpine)
            sudo apk add --no-cache nodejs npm
            ;;
        *)
            # Fallback: use nvm
            echo -e "${YELLOW}[*]${NC} Using nvm to install Node.js..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            nvm install 20
            nvm use 20
            nvm alias default 20
            ;;
    esac

    if command -v node &> /dev/null; then
        echo -e "${GREEN}[✓]${NC} Node.js installed: $(node -v)"
    else
        echo -e "${RED}[✗]${NC} Failed to install Node.js"
        exit 1
    fi
}

# Install npm if not present
install_npm() {
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        echo -e "${GREEN}[✓]${NC} npm already installed: $NPM_VERSION"
        return 0
    fi

    echo -e "${YELLOW}[*]${NC} Installing npm..."

    case $OS in
        ubuntu|debian)
            sudo apt-get install -y npm
            ;;
        centos|rhel|fedora|rocky|almalinux)
            sudo yum install -y npm || sudo dnf install -y npm
            ;;
        alpine)
            sudo apk add --no-cache npm
            ;;
        *)
            echo -e "${RED}[✗]${NC} Please install npm manually"
            exit 1
            ;;
    esac
}

# Install Claude Code
install_claude_code() {
    echo -e "${YELLOW}[*]${NC} Installing Claude Code..."

    if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} Claude Code installed globally"
    elif sudo npm install -g @anthropic-ai/claude-code 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} Claude Code installed globally (with sudo)"
    else
        echo -e "${YELLOW}[!]${NC} Global install failed, setting up npx alias..."
        SHELL_RC="$HOME/.bashrc"
        [ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"
        if ! grep -q "alias claude=" "$SHELL_RC" 2>/dev/null; then
            echo 'alias claude="npx @anthropic-ai/claude-code"' >> "$SHELL_RC"
            echo -e "${GREEN}[✓]${NC} Added claude alias to $SHELL_RC"
        fi
    fi
}

# Install Happy Coder (Claude Code Mobile Client)
install_happy_coder() {
    echo -e "${YELLOW}[*]${NC} Installing Happy Coder..."

    if npm install -g happy-coder 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} Happy Coder installed globally"
    elif sudo npm install -g happy-coder 2>/dev/null; then
        echo -e "${GREEN}[✓]${NC} Happy Coder installed globally (with sudo)"
    else
        echo -e "${YELLOW}[!]${NC} Happy Coder install failed, try manually: npm install -g happy-coder"
    fi
}

# Verify installation
verify_installation() {
    echo ""
    echo -e "${BLUE}[*]${NC} Verifying installation..."

    # Source shell config
    [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc" 2>/dev/null || true
    [ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc" 2>/dev/null || true

    if command -v claude &> /dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "installed")
        echo -e "${GREEN}[✓]${NC} Claude Code: $CLAUDE_VERSION"
    else
        echo -e "${YELLOW}[!]${NC} Run 'source ~/.bashrc' or start a new terminal, then run 'claude'"
    fi
}

# Print completion message
print_completion() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete!               ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "Next steps:"
    echo -e "  1. Run ${YELLOW}source ~/.bashrc${NC} (or start new terminal)"
    echo -e "  2. Run ${YELLOW}claude${NC} to start Claude Code"
    echo -e "  3. Login with your Anthropic account"
    echo ""
}

# Main
main() {
    detect_os
    check_permissions
    install_nodejs
    install_npm
    install_claude_code
    install_happy_coder
    verify_installation
    print_completion
}

main "$@"
