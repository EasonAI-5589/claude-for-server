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

## 代理配置

安装 Claude Code 需要访问外网，不同服务器的代理配置方式不同。

### 智源 (BAAI) 服务器

智源服务器已预装 Clash，位于 `/share/project/yunfan/clash`

#### 快速启动 Snippet（推荐放入 tmux）

```bash
# 一键启动代理 + Happy (复制粘贴即可)
pkill clash 2>/dev/null
cd /share/project/guoyichen/clash && nohup ./clash -d . > /dev/null 2>&1 &
sleep 2
export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890
cd /share/project/guoyichen
happy
```

**使用方法**：
```bash
# 1. 先开 tmux 会话
tmux new -s happy

# 2. 粘贴上面的 snippet

# 3. 手机扫码连接 Happy
```

#### 使用自己的 Clash 配置（推荐）

云帆预装的 Clash 配置可能不稳定，建议使用自己的订阅：

```bash
# 1. 复制 Clash 到自己目录
cp -r /share/project/yunfan/clash /share/project/guoyichen/

# 2. 从本地 Mac 上传订阅配置（Clash Verge 配置路径）
# 在 Mac 本地终端运行：
scp "/Users/你的用户名/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/profiles/你的配置.yaml" "BAAI2-ssh.platform-sz.jingneng-inner.ac.cn:/share/project/guoyichen/clash/config.yaml"

# 3. 重启 Clash
pkill clash
cd /share/project/guoyichen/clash && nohup ./clash -d . > /dev/null 2>&1 &
```

#### 节点选择建议

**⚠️ 重要**：香港节点可能被 Anthropic 封禁（返回 403），建议使用：
- 🇯🇵 日本节点（推荐，最稳定）
- 🇺🇸 美国节点
- 🇸🇬 新加坡节点

**切换节点**：
```bash
# 查看可用节点
curl -s http://127.0.0.1:9090/proxies | grep -o '"name":"[^"]*"' | head -20

# 切换到日本节点
curl -X PUT "http://127.0.0.1:9090/proxies/🚀%20节点选择" -d '{"name":"🇯🇵 日本 01"}'

# 验证当前节点
curl -s http://127.0.0.1:9090/proxies/🚀%20节点选择 | grep -o '"now":"[^"]*"'
```

#### OAuth 登录问题

如果 `/login` 时出现 `OAuth error: Failed to fetch user roles` 或 TLS 错误：

1. **换节点**：香港节点经常被封，换成日本/美国
2. **多试几次**：网络不稳定时重试即可
3. **用 Happy 替代**：`happy` 命令用手机扫码，不需要 OAuth 回调

#### 分步说明

```bash
# 1. 启动 Clash（如果没启动）
cd /share/project/yunfan/clash
./clash -d . &

# 2. 设置代理环境变量
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890

# 3. 测试代理
curl -I https://www.google.com
# 返回 HTTP/2 200 表示成功

# 4. 然后安装 Claude Code
curl -fsSL https://raw.githubusercontent.com/EasonAI-5589/claude-for-server/master/install.sh | bash
```

> **注意**：如果提示 `address already in use`，说明 Clash 已经在运行，直接设置环境变量即可。

### AutoDL 服务器

> 待完善

### 恒源云服务器

> 待完善

### 阿里云/腾讯云

> 待完善

---

## 环境变量配置（可选）

```bash
# 添加到 ~/.bashrc
export ANTHROPIC_API_KEY="your-api-key"
```

## License

MIT
