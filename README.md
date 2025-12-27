# Claude for Server

一键在服务器上安装 Claude Code，解决 `npm: command not found` 问题。

## 问题

在服务器上运行 Claude Code 时常见的报错：

```bash
$ claude
-bash: claude: command not found

$ npm install -g @anthropic-ai/claude-code
-bash: npm: command not found
```

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/EasonAI-5589/claude-for-server/main/install.sh | bash
```

或者使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/EasonAI-5589/claude-for-server/main/install.sh | bash
```

## 手动安装

如果一键安装失败，可以手动执行：

```bash
# 1. 克隆仓库
git clone https://github.com/EasonAI-5589/claude-for-server.git
cd claude-for-server

# 2. 运行安装脚本
chmod +x install.sh
./install.sh
```

## 支持的系统

| 系统 | 状态 |
|------|------|
| Ubuntu/Debian | ✅ |
| CentOS/RHEL/Rocky | ✅ |
| Fedora | ✅ |
| Alpine | ✅ |
| 其他 Linux | ⚠️ (使用 nvm) |

## 安装内容

脚本会自动安装：

1. **Node.js 20.x** - 使用 NodeSource 官方源
2. **npm** - Node.js 包管理器
3. **Claude Code** - Anthropic 官方 CLI 工具
4. **Happy Coder** - Claude Code 移动端客户端 CLI ([happy.engineering](https://happy.engineering/))

## 安装后

```bash
# 刷新环境变量
source ~/.bashrc

# 启动 Claude Code
claude

# 启动 Happy Coder (可用手机控制)
happy
```

## 常见问题

### Q: 安装后 `claude` 命令仍然找不到？

```bash
# 刷新 shell 配置
source ~/.bashrc

# 或者开启新的终端会话
```

### Q: 没有 sudo 权限怎么办？

脚本会尝试使用 nvm 在用户目录安装 Node.js，不需要 root 权限。

### Q: 如何卸载？

```bash
npm uninstall -g @anthropic-ai/claude-code
```

## 环境变量配置（可选）

如果需要配置代理或 API Key：

```bash
# 添加到 ~/.bashrc
export ANTHROPIC_API_KEY="your-api-key"

# 如果需要代理
export HTTP_PROXY="http://127.0.0.1:7890"
export HTTPS_PROXY="http://127.0.0.1:7890"
```

## License

MIT
