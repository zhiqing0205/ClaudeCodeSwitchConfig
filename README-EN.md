# Claude Config Switcher (CCS)

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Linux%20|%20macOS-brightgreen" alt="Platform">
  <img src="https://img.shields.io/badge/Shell-Bash%204.0+-blue" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
</p>

<p align="center">
  🤖 <strong>Elegantly manage multiple Claude API configurations with one-click switching!</strong>
</p>

<p align="center">
  <strong>One-line installation:</strong><br>
  <code>curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash</code>
</p>

<p align="center">
  <a href="README.md">中文</a> | <a href="README-EN.md">English</a>
</p>

---

Claude Config Switcher (CCS) is a powerful and beautiful command-line tool designed specifically for managing multiple Claude API configurations. It supports quick switching between different API endpoints and keys, perfectly integrated with Claude Code.

## ✨ Features

- 🎨 **Beautiful Interface**: Colored output, icons, and formatted tables
- 🔄 **Quick Switching**: Support switching by numbers or names
- ➕ **Complete Management**: Add, delete, edit, and list configurations
- 🤖 **Claude Integration**: Auto-generate Claude Code settings.json
- 📁 **Standard Directory**: Store configurations in ~/.claude/ directory
- 🖥️ **Cross-platform**: Compatible with Linux and macOS
- 🚀 **One-click Install**: Auto-register to bashrc, ready to use

## 🚀 One-click Installation

**Copy and paste this command to install instantly:**

```bash
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash
```

After installation:
```bash
source ~/.bashrc  # Reload configuration
ccs              # Start using!
```

### Alternative Installation

<details>
<summary>📦 Local Installation</summary>

```bash
# Download project files to any directory
git clone https://github.com/zhiqing0205/ClaudeCodeSwitchConfig.git
cd ClaudeCodeSwitchConfig

# Run installation script
./setup.sh

# Reload shell configuration
source ~/.bashrc
```
</details>

## 🎯 Quick Usage

### Basic Commands

```bash
# Launch interactive menu
ccs

# Add new configuration
ccs add

# Switch to specified configuration
ccs production

# Switch to the 1st configuration
ccs 1

# View all configurations
ccs list

# Edit configuration
ccs edit

# Delete configuration  
ccs delete

# View help
ccs help
```

### Interactive Menu

Run `ccs` to enter the beautiful interactive menu:

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  🤖 Claude Config Switcher 1.0.0 - Configuration Management Menu            ║
╚══════════════════════════════════════════════════════════════════════════════╝

🔧 Current Configuration: production

╔══════════════════════════════════════════════════════════════════════════════╗
║  🤖 Claude Config Switcher 1.0.0 - Claude API Configuration List            ║
╚══════════════════════════════════════════════════════════════════════════════╝

 1. official               [Current]
    Base URL: https://api.anthropic.com
    API Key:  ...3f2a

 2. custom                 
    Base URL: https://my-proxy.com
    API Key:  ...8b1c

────────────────────────────────────────────────────────────────────────────────
Operation Options:
[1-9]     Switch to corresponding numbered configuration
[a]dd     Add new configuration
[d]elete  Delete configuration
[e]dit    Edit configuration
[l]ist    Refresh configuration list
[h]elp    Show help information
[q]uit    Exit program
────────────────────────────────────────────────────────────────────────────────

Please select operation: 
```

## 📖 Features in Detail

### 1. Add Configuration

```bash
ccs add
```

Follow prompts to enter:
- **Configuration Name**: e.g., `production`, `development`, `custom`
- **Base URL**: API endpoint address
- **API Key**: Your Claude API key

### 2. Switch Configuration

```bash
# Method 1: Use configuration name
ccs production

# Method 2: Use number
ccs 1

# Method 3: Interactive selection
ccs
# Then enter number to select
```

After switching configuration, CCS will automatically:
- Generate `~/.claude/settings.json` file
- Update environment variable settings
- Configure Claude Code permissions
- Set status bar display

### 3. Edit Configuration

```bash
ccs edit
# or
ccs edit production
```

Supports modifying:
- Base URL
- API Key
- Other configuration parameters

### 4. Delete Configuration

```bash
ccs delete
```

Safe deletion features:
- List all configurations for selection
- Confirmation prompt to prevent accidental deletion
- Auto-cleanup related files

## 📁 File Structure

```
~/.claude/
├── keys.conf       # Configuration file (INI format)
├── settings.json   # Claude Code settings file (auto-generated)
└── current         # Current active configuration name
```

### Configuration File Format

`~/.claude/keys.conf` uses INI format:

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

### Auto-generated settings.json

When switching configurations, CCS automatically generates `~/.claude/settings.json`:

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
      "Read(*)",
      "Write(*)",
      ...
    ],
    "deny": []
  },
  "apiKeyHelper": "echo 'sk-ant-xxx'",
  "statusLine": {
    "type": "command",
    "command": "echo '🤖 Claude [production]'",
    "padding": 0
  }
}
```

## 🛠️ Advanced Usage

### Script Integration

Get current configuration in your scripts:

```bash
#!/bin/bash

# Get current configuration name
current_config=$(cat ~/.claude/current 2>/dev/null || echo "")

# Function to get configuration values
get_claude_config() {
    local key="$1"
    awk -v section="$current_config" -v key="$key" '
        $0 == "[" section "]" { in_section = 1; next }
        in_section && /^\s*\[.*\]\s*$/ { in_section = 0; exit }
        in_section {
            if (index($0, key " =") == 1 || index($0, key "=") == 1) {
                split($0, parts, "=")
                if (length(parts) > 1) {
                    value = parts[2]
                    for (i = 3; i <= length(parts); i++) {
                        value = value "=" parts[i]
                    }
                    sub(/^[ \t]*/, "", value)
                    sub(/[ \t]*$/, "", value)
                    print value
                    exit
                }
            }
        }
    ' ~/.claude/keys.conf
}

# Usage example
api_key=$(get_claude_config "apiKey")
base_url=$(get_claude_config "baseUrl")

echo "Current config: $current_config"
echo "API Key: ${api_key:0:10}..."
echo "Base URL: $base_url"
```

## 🔧 System Requirements

- **Operating System**: Linux or macOS
- **Shell**: Bash 4.0 or higher
- **Tools**: awk, grep, sed (usually pre-installed)
- **Permissions**: Write access to ~/.claude/ directory and ~/.bashrc file

## 📦 Installation Methods

### Method 1: One-click Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash
```

Automatically completes:
- Create ~/.claude directory
- Register ccs command to ~/.bashrc
- Create sample configuration files
- Verify installation

### Method 2: Local Install

```bash
# 1. Create directory
mkdir -p ~/.claude

# 2. Copy script
cp ccs ~/.claude/
chmod +x ~/.claude/ccs

# 3. Add alias to ~/.bashrc
echo "alias ccs='$HOME/.claude/ccs'" >> ~/.bashrc

# 4. Reload configuration
source ~/.bashrc
```

## 🗑️ Uninstall

```bash
# Use installation script to uninstall
./install-online.sh --uninstall

# Or manually delete
sed -i '/alias ccs=/d' ~/.bashrc
rm -rf ~/.claude
```

## 💡 Usage Tips

### 1. Quick Environment Switching

```bash
# During development
ccs development

# For production  
ccs production

# For testing
ccs testing
```

### 2. Configuration Backup

```bash
# Backup configuration file
cp ~/.claude/keys.conf ~/.claude/keys.conf.backup

# Restore configuration file  
cp ~/.claude/keys.conf.backup ~/.claude/keys.conf
```

## 🤔 FAQ

### Q: How to update API Key?
A: Use `ccs edit` command to edit the corresponding configuration.

### Q: Where are configuration files stored?
A: All configurations are stored in `~/.claude/keys.conf` file.

### Q: How to know which configuration is currently active?
A: Run `ccs list` to view, current configuration will be marked as `[Current]`.

### Q: Can I use multiple configurations simultaneously?
A: No, only one configuration can be active at a time.

### Q: Does it support team sharing configurations?
A: Yes, you can share the `keys.conf` file with team members.

## 🤝 Contributing

Issues and Pull Requests are welcome!

### Development

```bash
# Clone project
git clone https://github.com/zhiqing0205/ClaudeCodeSwitchConfig.git
cd ClaudeCodeSwitchConfig

# Modify code
# ...

# Test
./ccs help

# Commit
git add .
git commit -m "feat: add new feature"
git push
```

## 📄 License

MIT License

## 🙏 Acknowledgments

- Thanks to [Anthropic](https://www.anthropic.com) for providing the powerful Claude API
- Thanks to all users who provided feedback and suggestions

## 📞 Contact

- **Author**: zhiqing0205
- **GitHub**: https://github.com/zhiqing0205/ClaudeCodeSwitchConfig
- **Issues**: https://github.com/zhiqing0205/ClaudeCodeSwitchConfig/issues

---

**Enjoy the pleasant Claude API configuration management experience!** 🤖✨