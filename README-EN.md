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
- 🖥️ **Cross-platform**: Compatible with Linux and macOS, supports bash/zsh
- 🚀 **One-click Install**: Online installation, auto-register commands, ready to use
- 📝 **Template System**: Customizable settings.json template with variable substitution
- 🔄 **Auto-update**: Smart version detection, one-click update to latest version

## 🚀 One-click Installation

**Copy and paste this command to install instantly:**

```bash
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash
```

**Key Advantages:**
- ⚡ **Lightning Fast**: One command, 30-second installation
- 🎯 **Smart Detection**: Auto-detect bash/zsh, supports Linux/macOS
- 🚀 **Ready to Use**: Auto-launch after installation, no manual setup
- 🔧 **Zero Dependencies**: No additional tools or libraries required

After installation, it will auto-launch. For manual start:
```bash
source ~/.bashrc  # or ~/.zshrc (macOS)
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

# Customize template
ccs template

# Check for updates
ccs update

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
[t]emplate Edit settings.json template
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

### 5. Template Customization

```bash
ccs template
```

CCS supports customizing settings.json templates, giving you full control over the generated configuration files:

**Template Variables:**
- `{{API_KEY}}` - Current configuration's API Key
- `{{BASE_URL}}` - Current configuration's Base URL
- `{{CONFIG_NAME}}` - Current configuration name

**Use Cases:**
- Custom permission configurations
- Add specific environment variables
- Modify Claude Code behavior settings
- Personalize work environment

### 6. Auto-update System

```bash
# Manual update check
ccs update
```

**Smart Update Features:**
- 🔍 **Auto Detection**: Check for new versions on each startup (6-hour cache)
- 🚀 **One-click Update**: Prompt for update when new version detected
- 🛡️ **Safety Mechanism**: Auto-backup, rollback on failure
- 🔄 **Zero Interruption**: Auto-restart after update, maintain workflow

## 📁 File Structure

```
~/.claude/
├── keys.conf         # Configuration file (INI format)
├── settings.json     # Claude Code settings file (auto-generated)
├── template.json     # settings.json template file
├── current           # Current active configuration name
└── .version_cache    # Version check cache file
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

### Template File Format

`~/.claude/template.json` is the template used to generate settings.json:

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

### Auto-generated settings.json

When switching configurations, CCS automatically uses the template to generate `~/.claude/settings.json`:

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

## 📦 Installation Methods Comparison

| Installation Method | Command | Advantages | Use Cases |
|-------------------|---------|------------|----------|
| **Online One-click** (Recommended) | `curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh \| bash` | Auto-download latest version<br>Smart environment detection<br>Zero-config installation | First-time install<br>Quick deployment |
| **Local Install** | `git clone` + `./setup.sh` | Offline installation<br>Review source code<br>Support custom modifications | Development/debugging<br>Offline environments |

### Online Installation Features

- 🌍 **Latest Version**: Directly download latest version from GitHub
- 🎯 **Smart Adaptation**: Auto-detect Linux/macOS + bash/zsh
- ⚡ **Ready to Use**: Auto-launch CCS after installation
- 🛡️ **Safety Check**: Verify network connection and system compatibility

## 🗑️ Uninstall

```bash
# Online installation users
curl -fsSL https://raw.githubusercontent.com/zhiqing0205/ClaudeCodeSwitchConfig/main/install-online.sh | bash -s -- --uninstall

# Local installation users
./setup.sh --uninstall

# Manual removal
sed -i '/alias ccs=/d' ~/.bashrc  # or ~/.zshrc
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

### 3. Template Customization Tips

```bash
# Edit template
ccs template

# Common template variables examples
# {{API_KEY}}     - Replace with current config's API Key
# {{BASE_URL}}    - Replace with current config's Base URL
# {{CONFIG_NAME}} - Replace with current config name

# Add custom environment variables
"env": {
  "ANTHROPIC_API_KEY": "{{API_KEY}}",
  "ANTHROPIC_BASE_URL": "{{BASE_URL}}",
  "CUSTOM_VAR": "value-for-{{CONFIG_NAME}}"
}
```

### 4. Update Management

```bash
# Manual update check
ccs update

# View current version
ccs help | grep -i version

# Updates auto-backup current version, auto-rollback on failure
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

### Q: How to customize settings.json format?
A: Use `ccs template` command to edit the template file, supports variable substitution.

### Q: What if update fails?
A: CCS auto-backups and rollbacks, you can also manually restore backup files.

### Q: Which operating systems are supported?
A: Supports Linux and macOS, auto-detects bash/zsh environments.

### Q: Is one-click installation safe?
A: The script is open-source and auditable, validates network and system compatibility before installation.

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