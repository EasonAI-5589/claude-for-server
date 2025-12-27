#!/bin/bash
set -e

echo "╔══════════════════════════════════════════════╗"
echo "║   Claude Code Server Installer (Ubuntu)      ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# 智源服务器：启动 Clash 代理
setup_baai_proxy() {
    CLASH_DIR="/share/project/yunfan/clash"
    if [ -d "$CLASH_DIR" ]; then
        echo "[*] 检测到智源服务器，配置代理..."

        # 检查 Clash 是否已运行
        if ! netstat -tlnp 2>/dev/null | grep -q ":7890"; then
            cd "$CLASH_DIR"
            ./clash -d . > /dev/null 2>&1 &
            sleep 2
            echo "[✓] Clash 已启动"
        else
            echo "[✓] Clash 已在运行"
        fi

        export http_proxy=http://127.0.0.1:7890
        export https_proxy=http://127.0.0.1:7890
        echo "[✓] 代理已设置: 127.0.0.1:7890"
    fi
}

# 安装 Node.js
install_nodejs() {
    if command -v node &> /dev/null; then
        echo "[✓] Node.js 已安装: $(node -v)"
        return 0
    fi

    echo "[*] 安装 Node.js 20.x..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    echo "[✓] Node.js 安装完成: $(node -v)"
}

# 安装 Claude Code
install_claude_code() {
    echo "[*] 安装 Claude Code..."
    npm install -g @anthropic-ai/claude-code
    echo "[✓] Claude Code 安装完成"
}

# 安装 Happy Coder
install_happy_coder() {
    echo "[*] 安装 Happy Coder..."
    npm install -g happy-coder
    echo "[✓] Happy Coder 安装完成"
}

# 主流程
main() {
    setup_baai_proxy
    install_nodejs
    install_claude_code
    install_happy_coder

    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║            安装完成！                        ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    echo "使用方法:"
    echo "  claude    # 启动 Claude Code"
    echo "  happy     # 启动 Happy (手机控制)"
    echo ""
}

main
