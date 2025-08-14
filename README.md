# Claude Config Switcher (CCS)

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Linux%20|%20macOS-brightgreen" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash%204.0+-blue" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

<p align="center">
  🤖 <strong>优雅管理多个 Claude API 配置，一键切换！</strong>
</p>

<p align="center">
  <strong>一行命令安装：</strong><br>
  <code>curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash</code>
</p>

<p align="center">
  <a href="README.md">中文</a> | <a href="README-EN.md">English</a>
</p>

---

Claude Config Switcher (CCS) 是一个功能强大、界面美观的命令行工具，专门用于管理多个 Claude API 配置。支持快速切换不同的 API 端点和密钥，完美适配 Claude Code 使用场景。

## ✨ 特性

- 🎨 **美观界面**: 彩色输出、图标装饰、格式化表格
- 🔄 **快速切换**: 支持数字、名称快速切换配置
- ➕ **完整管理**: 添加、删除、编辑、列出配置
- 🤖 **Claude 集成**: 自动生成 Claude Code settings.json
- 📁 **标准目录**: 配置存储在 ~/.claude/ 目录
- 🖥️ **跨平台**: 兼容 Linux 和 macOS，支持 bash/zsh
- 🚀 **一键安装**: 在线安装，自动注册命令，即装即用
- 📝 **模板系统**: 可自定义 settings.json 模板，支持变量替换
- 🔄 **自动更新**: 智能检测新版本，一键更新到最新版

## 🚀 一键安装

**复制粘贴这行命令，立即安装：**

```bash
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash
```

**特色优势：**
- ⚡ **极速安装**: 一行命令，30秒完成安装
- 🎯 **智能检测**: 自动识别 bash/zsh，适配 Linux/macOS
- 🚀 **即装即用**: 安装完成自动启动，无需手动配置
- 🔧 **零依赖**: 无需额外安装任何工具或库

安装完成后会自动启动，如需手动启动：
```bash
source ~/.bashrc  # 或 ~/.zshrc (macOS)
ccs              # 开始使用！
```

### 其他安装方式

<details>
<summary>📦 本地安装</summary>

```bash
# 下载项目文件到任意目录
git clone https://github.com/zhiqing0205/ClaudeCodeSwitchConfig.git
cd ClaudeCodeSwitchConfig

# 运行安装脚本
./setup.sh

# 重新加载 shell 配置
source ~/.bashrc
```
</details>

## 🎯 快速使用

### 基本命令

```bash
# 启动交互式菜单
ccs

# 添加新配置
ccs add

# 切换到指定配置
ccs production

# 切换到第1个配置
ccs 1

# 查看所有配置
ccs list

# 编辑配置
ccs edit

# 删除配置  
ccs delete

# 自定义模板
ccs template

# 检查更新
ccs update

# 查看帮助
ccs help
```

### 交互式菜单

运行 `ccs` 进入美观的交互式菜单：

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  🤖 Claude Config Switcher 1.0.0 - 配置管理主菜单                            ║
╚══════════════════════════════════════════════════════════════════════════════╝

🔧 当前配置: production

╔══════════════════════════════════════════════════════════════════════════════╗
║  🤖 Claude Config Switcher 1.0.0 - Claude API 配置列表                       ║
╚══════════════════════════════════════════════════════════════════════════════╝

 1. official               [当前]
    Base URL: https://api.anthropic.com
    API Key:  ...3f2a

 2. custom                 
    Base URL: https://my-proxy.com
    API Key:  ...8b1c

────────────────────────────────────────────────────────────────────────────────
操作选项:
[1-9]     切换到对应编号的配置
[a]dd     添加新配置
[d]elete  删除配置
[e]dit    编辑配置
[t]emplate 编辑 settings.json 模板
[l]ist    刷新配置列表
[h]elp    显示帮助信息
[q]uit    退出程序
────────────────────────────────────────────────────────────────────────────────

请选择操作: 
```

## 📖 详细功能

### 1. 添加配置

```bash
ccs add
```

按提示输入：
- **配置名称**: 如 `production`, `development`, `custom`
- **Base URL**: API 端点地址
- **API Key**: 您的 Claude API 密钥

### 2. 切换配置

```bash
# 方式1: 使用配置名称
ccs production

# 方式2: 使用数字编号
ccs 1

# 方式3: 交互式选择
ccs
# 然后输入数字选择
```

切换配置后，CCS 会自动：
- 生成 `~/.claude/settings.json` 文件
- 更新环境变量设置
- 配置 Claude Code 权限
- 设置状态栏显示

### 3. 编辑配置

```bash
ccs edit
# 或
ccs edit production
```

支持修改：
- Base URL
- API Key
- 其他配置参数

### 4. 删除配置

```bash
ccs delete
```

安全删除功能：
- 列出所有配置供选择
- 确认提示防止误删
- 自动清理相关文件

### 5. 自定义模板

```bash
ccs template
```

CCS 支持自定义 settings.json 模板，让您完全控制生成的配置文件：

**模板变量：**
- `{{API_KEY}}` - 当前配置的 API Key
- `{{BASE_URL}}` - 当前配置的 Base URL
- `{{CONFIG_NAME}}` - 当前配置的名称

**使用场景：**
- 自定义权限配置
- 添加特定环境变量
- 修改 Claude Code 行为设置
- 个性化工作环境

### 6. 自动更新

```bash
# 手动检查更新
ccs update
```

**智能更新系统：**
- 🔍 **自动检测**: 每次启动自动检查新版本（6小时缓存）
- 🚀 **一键更新**: 检测到新版本时提示更新
- 🛡️ **安全机制**: 自动备份，更新失败自动回滚
- 🔄 **零中断**: 更新完成自动重启，保持工作流

## 📁 文件结构

```
~/.claude/
├── keys.conf         # 配置文件(INI格式)
├── settings.json     # Claude Code 设置文件(自动生成)
├── template.json     # settings.json 模板文件
├── current           # 当前激活的配置名称
└── .version_cache    # 版本检查缓存文件
```

### 配置文件格式

`~/.claude/keys.conf` 使用 INI 格式：

```ini
[official]
baseUrl = https://api.anthropic.com
apiKey = sk-ant-api03-xxxxx

[custom]
baseUrl = https://my-proxy.com
apiKey = custom-key-xxxxx

[development]
baseUrl = https://dev.anthropic.com
apiKey = sk-ant-dev-xxxxx
```

### 模板文件格式

`~/.claude/template.json` 是用于生成 settings.json 的模板：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "{{API_KEY}}",
    "ANTHROPIC_BASE_URL": "{{BASE_URL}}",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "permissions": {
    "allow": [
      "Bash(*)",
      "LS(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "MultiEdit(*)",
      "Glob(*)",
      "Grep(*)",
      "Task(*)",
      "WebFetch(*)",
      "WebSearch(*)",
      "TodoWrite(*)",
      "NotebookRead(*)",
      "NotebookEdit(*)"
    ],
    "deny": []
  },
  "apiKeyHelper": "echo '{{API_KEY}}'"
}
```

### 自动生成的 settings.json

当切换配置时，CCS 会自动使用模板生成 `~/.claude/settings.json`：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "sk-ant-xxx",
    "ANTHROPIC_BASE_URL": "https://api.anthropic.com",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
  },
  "permissions": {
    "allow": [
      "Bash(*)",
      "LS(*)",
      "Read(*)",
      "Write(*)",
      ...
    ],
    "deny": []
  },
  "apiKeyHelper": "echo 'sk-ant-xxx'"
}
```

## 🛠️ 高级用法

### 脚本集成

在您的脚本中获取当前配置：

```bash
#!/bin/bash

# 获取当前配置名称
current_config=$(cat ~/.claude/current 2>/dev/null || echo "")

# 获取配置值的函数
get_claude_config() {
    local key="$1"
    awk -v section="$current_config" -v key="$key" '
        $0 == "[" section "]" { in_section = 1; next }
        in_section && /^\s*\[.*\]\s*$/ { in_section = 0; exit }
        in_section {
            if (index($0, key " =") == 1 || index($0, key "=") == 1) {
                split($0, parts, "=", 2)
                value = parts[2]
                sub(/^[ \t]*/, "", value)
                sub(/[ \t]*$/, "", value)
                print value
                exit
            }
        }
    ' ~/.claude/keys.conf
}

# 使用示例
api_key=$(get_claude_config "apiKey")
base_url=$(get_claude_config "baseUrl")

echo "当前配置: $current_config"
echo "API Key: ${api_key:0:10}..."
echo "Base URL: $base_url"
```

### 环境变量集成

将配置导出为环境变量：

```bash
# 添加到您的脚本中
export_claude_config() {
    local current_config=$(cat ~/.claude/current 2>/dev/null)
    if [[ -n "$current_config" ]]; then
        export CLAUDE_CONFIG_NAME="$current_config"
        export ANTHROPIC_API_KEY=$(get_claude_config "apiKey")
        export ANTHROPIC_BASE_URL=$(get_claude_config "baseUrl")
    fi
}

export_claude_config
```

## 🔧 系统要求

- **操作系统**: Linux 或 macOS
- **Shell**: Bash 4.0 或更高版本
- **工具**: awk, grep, sed (系统通常自带)
- **权限**: 能够写入 ~/.claude/ 目录和 ~/.bashrc 文件

## 📦 安装方式对比

| 安装方式 | 命令 | 优势 | 适用场景 |
|---------|------|------|----------|
| **在线一键安装** (推荐) | `curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh \| bash` | 自动下载最新版本<br>智能检测系统环境<br>零配置安装 | 首次安装<br>快速部署 |
| **本地安装** | `git clone` + `./setup.sh` | 离线安装<br>可查看源码<br>支持自定义修改 | 开发调试<br>离线环境 |

### 在线安装特色功能

- 🌍 **最新版本**: 直接从 GitHub 下载最新版本
- 🎯 **智能适配**: 自动检测 Linux/macOS + bash/zsh
- ⚡ **即装即用**: 安装完成自动启动 CCS
- 🛡️ **安全检查**: 验证网络连接和系统兼容性

## 🗑️ 卸载

```bash
# 在线安装用户
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash -s -- --uninstall

# 本地安装用户
./setup.sh --uninstall

# 手动删除
sed -i '/alias ccs=/d' ~/.bashrc  # 或 ~/.zshrc
rm -rf ~/.claude
```

## 💡 使用技巧

### 1. 快速切换工作环境

```bash
# 开发时
ccs development

# 上线时  
ccs production

# 测试时
ccs testing
```

### 2. 批量管理配置

```bash
# 查看所有配置
ccs list

# 编辑多个配置
for config in official custom development; do
    ccs edit $config
done
```

### 3. 备份配置

```bash
# 备份配置文件
cp ~/.claude/keys.conf ~/.claude/keys.conf.backup

# 恢复配置文件  
cp ~/.claude/keys.conf.backup ~/.claude/keys.conf
```

### 4. 模板定制技巧

```bash
# 编辑模板
ccs template

# 常用模板变量示例
# {{API_KEY}}     - 替换为当前配置的 API Key
# {{BASE_URL}}    - 替换为当前配置的 Base URL
# {{CONFIG_NAME}} - 替换为当前配置名称

# 添加自定义环境变量
"env": {
  "ANTHROPIC_API_KEY": "{{API_KEY}}",
  "ANTHROPIC_BASE_URL": "{{BASE_URL}}",
  "CUSTOM_VAR": "value-for-{{CONFIG_NAME}}"
}
```

### 5. 更新管理

```bash
# 手动检查更新
ccs update

# 查看当前版本
ccs help | grep -i version

# 更新会自动备份当前版本，失败时自动回滚
```

## 🤔 常见问题

### Q: 如何更新 API Key？
A: 使用 `ccs edit` 命令编辑对应配置。

### Q: 配置文件在哪里？
A: 所有配置存储在 `~/.claude/keys.conf` 文件中。

### Q: 如何知道当前使用的是哪个配置？
A: 运行 `ccs list` 查看，当前配置会标记为 `[当前]`。

### Q: 可以同时使用多个配置吗？
A: 不可以，同一时间只能激活一个配置。

### Q: 支持团队共享配置吗？
A: 可以，将 `keys.conf` 文件共享给团队成员即可。

### Q: 如何自定义 settings.json 格式？
A: 使用 `ccs template` 命令编辑模板文件，支持变量替换。

### Q: 更新失败了怎么办？
A: CCS 会自动备份和回滚，也可以手动恢复备份文件。

### Q: 支持哪些操作系统？
A: 支持 Linux 和 macOS，自动检测 bash/zsh 环境。

### Q: 一键安装安全吗？
A: 脚本开源可审查，安装前会验证网络和系统兼容性。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发

```bash
# 克隆项目
git clone https://github.com/zhiqing0205/ClaudeCodeSwitchConfig.git
cd ClaudeCodeSwitchConfig

# 修改代码
# ...

# 测试
./ccs help

# 提交
git add .
git commit -m "feat: add new feature"
git push
```

## 📄 许可证

MIT License

## 🙏 致谢

- 感谢 [Anthropic](https://www.anthropic.com) 提供强大的 Claude API
- 感谢所有提供反馈和建议的用户

## 📞 联系

- **作者**: zhiqing0205
- **GitHub**: https://github.com/zhiqing0205/ClaudeCodeSwitchConfig
- **Issue**: https://github.com/zhiqing0205/ClaudeCodeSwitchConfig/issues

---

**享受愉快的 Claude API 配置管理体验！** 🤖✨