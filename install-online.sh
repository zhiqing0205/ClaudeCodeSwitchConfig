#!/bin/bash

# =============================================================================
# Claude Config Switcher (CCS) 在线一键安装脚本
# 
# 使用方法：
# curl -fsSL https://raw.githubusercontent.com/zhiqing0205/claude-config-switcher/main/install-online.sh | bash
# 
# 功能：
# - 自动下载最新版本的CCS
# - 创建 ~/.claude 目录
# - 安装 ccs 命令到系统
# - 自动注册到 ~/.bashrc
# - 创建示例配置文件
# 
# 作者: zhiqing0205
# GitHub: https://github.com/zhiqing0205/claude-config-switcher
# =============================================================================

set -euo pipefail

# --- 全局变量 ---
SCRIPT_NAME="Claude Config Switcher"
VERSION="1.0.0"
GITHUB_USER="zhiqing0205"
REPO_NAME="ClaudeCodeSwitchConfig"
REPO_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}"
RAW_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/main"

CLAUDE_DIR="${HOME}/.claude"
KEYS_FILE="${CLAUDE_DIR}/keys.conf"
CCS_SCRIPT="${CLAUDE_DIR}/ccs"
TEMPLATE_FILE="${CLAUDE_DIR}/template.json"

# 检测shell配置文件
if [[ "$OSTYPE" == "darwin"* ]] && [[ "$SHELL" == */zsh ]]; then
    SHELL_RC_FILE="${HOME}/.zshrc"
    SHELL_NAME="zsh"
elif [[ -f "${HOME}/.zshrc" ]] && [[ "$SHELL" == */zsh ]]; then
    SHELL_RC_FILE="${HOME}/.zshrc"
    SHELL_NAME="zsh"
else
    SHELL_RC_FILE="${HOME}/.bashrc"
    SHELL_NAME="bash"
fi

# 颜色和图标定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m'

ICON_SUCCESS="✅"
ICON_ERROR="❌"
ICON_WARNING="⚠️"
ICON_INFO="ℹ️"
ICON_CLAUDE="🤖"
ICON_ROCKET="🚀"

# =============================================================================
# 辅助函数
# =============================================================================

print_color() {
    local color="$1"
    local message="$2"
    printf "${color}%s${NC}\n" "$message"
}

print_success() {
    print_color "$GREEN" "$ICON_SUCCESS $1"
}

print_error() {
    print_color "$RED" "$ICON_ERROR $1" >&2
}

print_warning() {
    print_color "$YELLOW" "$ICON_WARNING $1"
}

print_info() {
    print_color "$BLUE" "$ICON_INFO $1"
}

print_banner() {
    clear
    print_color "$BOLD$GREEN" "  ╔═══════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ║  $ICON_CLAUDE   Claude Config Switcher (CCS)   $ICON_CLAUDE                   ║"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ║     在线一键安装 - 优雅管理 Claude API 配置！                 ║"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ╚═══════════════════════════════════════════════════════════════╝"
    echo
    print_color "$CYAN" "  GitHub: $REPO_URL"
    print_color "$CYAN" "  作者: $GITHUB_USER"
    echo
}

# 检查系统要求
check_requirements() {
    print_info "检查系统要求..."
    
    # 检查必要工具
    local tools=("curl" "awk" "grep" "sed")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_error "缺少必要工具: $tool"
            print_info "请安装 $tool 后重试"
            exit 1
        fi
    done
    
    # 检查 bash 版本
    if [[ "${BASH_VERSION%%.*}" -lt 4 ]]; then
        print_error "需要 Bash 4.0 或更高版本，当前版本: $BASH_VERSION"
        exit 1
    fi
    
    # 检查网络连接
    if ! curl -fsSL --connect-timeout 10 "$RAW_URL/README.md" > /dev/null; then
        print_error "无法连接到 GitHub，请检查网络连接"
        exit 1
    fi
    
    print_success "系统要求检查通过"
}

# 创建Claude目录
create_claude_dir() {
    print_info "创建 Claude 配置目录..."
    
    if [[ ! -d "$CLAUDE_DIR" ]]; then
        if mkdir -p "$CLAUDE_DIR" && chmod 700 "$CLAUDE_DIR"; then
            print_success "已创建目录: $CLAUDE_DIR"
        else
            print_error "无法创建目录: $CLAUDE_DIR"
            exit 1
        fi
    else
        print_info "目录已存在: $CLAUDE_DIR"
    fi
    
    # 创建keys.conf文件
    if [[ ! -f "$KEYS_FILE" ]]; then
        touch "$KEYS_FILE"
        chmod 600 "$KEYS_FILE"
        print_success "已创建配置文件: $KEYS_FILE"
    else
        print_info "配置文件已存在: $KEYS_FILE"
    fi
}

# 下载CCS相关文件
download_ccs_files() {
    print_info "下载最新版本的 CCS 文件..."
    
    # 要下载的文件列表
    local files=("ccs" "setup.sh")
    local success_count=0
    local failed_files=()
    
    for file in "${files[@]}"; do
        print_info "正在下载: $file"
        
        local temp_file
        temp_file=$(mktemp)
        
        if curl -fsSL "$RAW_URL/$file" -o "$temp_file"; then
            # 确定目标路径
            local target_path
            if [[ "$file" == "ccs" ]]; then
                target_path="$CCS_SCRIPT"
            else
                target_path="$CLAUDE_DIR/$file"
            fi
            
            mv "$temp_file" "$target_path"
            chmod +x "$target_path"
            print_success "已下载: $file -> $target_path"
            success_count=$((success_count + 1))
        else
            print_warning "下载失败: $file"
            failed_files+=("$file")
            rm -f "$temp_file"
        fi
    done
    
    echo
    
    # 显示下载结果
    if [[ $success_count -eq ${#files[@]} ]]; then
        print_success "所有文件下载完成"
    elif [[ $success_count -gt 0 ]]; then
        print_warning "部分文件下载成功 ($success_count/${#files[@]})"
        if [[ ${#failed_files[@]} -gt 0 ]]; then
            print_info "下载失败的文件:"
            for file in "${failed_files[@]}"; do
                echo "  - $file"
            done
        fi
    else
        print_error "所有文件下载失败"
        exit 1
    fi
    
    # 至少需要ccs脚本成功下载
    if [[ ! -f "$CCS_SCRIPT" ]]; then
        print_error "CCS 主脚本下载失败，无法继续安装"
        exit 1
    fi
}

# 注册CCS命令
register_ccs_command() {
    print_info "注册 CCS 命令到 ~/${SHELL_RC_FILE##*/}..."
    
    # 检查是否已经注册
    if grep -q "alias ccs=" "$SHELL_RC_FILE" 2>/dev/null; then
        print_warning "CCS 命令已在 ~/${SHELL_RC_FILE##*/} 中注册"
        print_info "在线安装中，自动重新安装..."
        
        # 移除旧的注册
        sed -i '/alias ccs=/d' "$SHELL_RC_FILE"
        sed -i '/# Claude Config Switcher (CCS)/d' "$SHELL_RC_FILE"
        sed -i '/# GitHub.*ClaudeCodeSwitchConfig/d' "$SHELL_RC_FILE"
        print_info "已移除旧的 CCS 命令注册"
    fi
    
    # 创建shell配置文件（如果不存在）
    if [[ ! -f "$SHELL_RC_FILE" ]]; then
        touch "$SHELL_RC_FILE"
        print_info "已创建 ~/${SHELL_RC_FILE##*/}"
    fi
    
    # 添加alias到shell配置文件
    {
        echo ""
        echo "# Claude Config Switcher (CCS) - Auto-generated by online installer"
        echo "# GitHub: $REPO_URL"
        echo "alias ccs='$CCS_SCRIPT'"
        echo ""
    } >> "$SHELL_RC_FILE"
    
    print_success "CCS 命令已注册到 ~/${SHELL_RC_FILE##*/}"
}

# 创建示例配置
create_sample_configs() {
    print_info "创建示例配置..."
    
    if [[ -s "$KEYS_FILE" ]]; then
        print_info "配置文件已有内容，跳过示例配置创建"
        return 0
    fi
    
    # 在线安装时默认创建示例配置，避免交互式输入问题
    print_info "自动创建示例配置..."
    
    cat > "$KEYS_FILE" << 'EOF'
[official]
baseUrl = https://api.anthropic.com
apiKey = sk-ant-your-api-key-here

[custom]
baseUrl = https://your-custom-endpoint.com
apiKey = your-custom-api-key-here
EOF
    
    print_success "示例配置已创建"
    print_warning "请使用 'ccs edit' 命令修改示例配置中的 API Key"
}

# 创建默认模板
create_default_template() {
    print_info "创建默认 settings.json 模板..."
    
    if [[ -f "$TEMPLATE_FILE" ]]; then
        print_info "模板文件已存在，跳过创建"
        return 0
    fi
    
    cat > "$TEMPLATE_FILE" << 'EOF'
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
EOF
    
    print_success "默认模板已创建: $TEMPLATE_FILE"
    print_info "使用 'ccs template' 命令可以自定义模板"
}

# 验证安装
verify_installation() {
    print_info "验证安装..."
    
    # 检查文件是否存在
    if [[ ! -f "$CCS_SCRIPT" ]] || [[ ! -x "$CCS_SCRIPT" ]]; then
        print_error "CCS 脚本文件不存在或不可执行"
        return 1
    fi
    
    # 检查shell配置文件注册
    if ! grep -q "alias ccs=" "$SHELL_RC_FILE" 2>/dev/null; then
        print_error "CCS 命令未正确注册到 ~/${SHELL_RC_FILE##*/}"
        return 1
    fi
    
    # 测试CCS脚本是否可执行（简单检查文件头）
    if [[ -x "$CCS_SCRIPT" ]] && head -1 "$CCS_SCRIPT" | grep -q '^#!/bin/bash'; then
        print_info "CCS 脚本格式正确"
    else
        print_warning "CCS 脚本可能有问题，但继续安装"
    fi
    
    print_success "安装验证通过"
    return 0
}

# 显示后续步骤
show_next_steps() {
    echo
    print_color "$BOLD$GREEN" "$ICON_ROCKET 安装完成！CCS (Claude Config Switcher) 已成功安装！"
    echo
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$WHITE" "  检测到 Shell: $SHELL_NAME"
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$YELLOW" "  如果自动启动失败，请手动运行："
    print_color "$WHITE" "     source ~/${SHELL_RC_FILE##*/}    # 重新加载配置"
    print_color "$WHITE" "     ccs                              # 启动 CCS"
    echo
    print_color "$GREEN" "  安装完成后 CCS 将自动启动！"
    echo
    print_color "$YELLOW" "  常用 CCS 命令："
    print_color "$WHITE" "     ccs              # 启动交互式菜单"
    print_color "$WHITE" "     ccs add          # 添加新的 API 配置"
    print_color "$WHITE" "     ccs list         # 查看所有配置"
    print_color "$WHITE" "     ccs help         # 查看帮助信息"
    echo
    print_color "$YELLOW" "  编辑示例配置 (如果创建了)："
    print_color "$WHITE" "     ccs edit official     # 编辑 official 配置"
    print_color "$WHITE" "     ccs edit custom       # 编辑 custom 配置"
    echo
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$WHITE" "  文件位置："
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$CYAN" "  配置目录: $CLAUDE_DIR"
    print_color "$CYAN" "  配置文件: $KEYS_FILE"
    print_color "$CYAN" "  CCS 脚本: $CCS_SCRIPT"
    echo
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$WHITE" "  项目信息："
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$CYAN" "  GitHub: $REPO_URL"
    print_color "$CYAN" "  作者: $GITHUB_USER"
    print_color "$CYAN" "  版本: $VERSION"
    echo
    print_color "$BOLD$GREEN" "  感谢使用 Claude Config Switcher！$ICON_CLAUDE"
    echo
}

# 卸载函数
uninstall() {
    print_banner
    print_warning "即将卸载 Claude Config Switcher (CCS)"
    echo
    
    read -rp "确认卸载? 这将移除命令注册但保留配置文件 (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "卸载已取消"
        exit 0
    fi
    
    # 从shell配置文件中移除alias
    if grep -q "alias ccs=" "$SHELL_RC_FILE" 2>/dev/null; then
        # 创建备份
        cp "$SHELL_RC_FILE" "${SHELL_RC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        
        # 移除CCS相关行
        sed -i '/# Claude Config Switcher (CCS)/d' "$SHELL_RC_FILE"
        sed -i '/alias ccs=/d' "$SHELL_RC_FILE"
        sed -i '/# GitHub.*ClaudeCodeSwitchConfig/d' "$SHELL_RC_FILE"
        
        # 清理多余的空行
        sed -i '/^$/N;/^\n$/d' "$SHELL_RC_FILE"
        
        print_success "已从 ~/${SHELL_RC_FILE##*/} 中移除 CCS 命令注册"
        print_info "已创建 ~/${SHELL_RC_FILE##*/} 备份"
    else
        print_info "未在 ~/${SHELL_RC_FILE##*/} 中找到 CCS 注册"
    fi
    
    # 删除CCS脚本
    if [[ -f "$CCS_SCRIPT" ]]; then
        rm -f "$CCS_SCRIPT"
        print_success "已删除 CCS 脚本"
    fi
    
    print_color "$GREEN" "CCS 命令注册已成功卸载"
    print_info "配置文件保留在: $CLAUDE_DIR"
    
    read -rp "是否也删除所有配置文件? (y/N): " confirm_config
    if [[ "$confirm_config" =~ ^[Yy]$ ]]; then
        rm -rf "$CLAUDE_DIR"
        print_success "配置文件已删除"
    fi
    
    print_info "请运行 'source ~/${SHELL_RC_FILE##*/}' 或重新打开终端以使更改生效"
}

# 主函数
main() {
    # 检查命令行参数
    case "${1:-}" in
        --uninstall|-u)
            uninstall
            exit 0
            ;;
        --help|-h)
            print_banner
            echo "用法: $0 [选项]"
            echo
            echo "选项:"
            echo "  --uninstall, -u    卸载 CCS"
            echo "  --help, -h         显示此帮助信息"
            echo
            echo "默认操作: 在线安装 Claude Config Switcher"
            echo
            echo "在线安装命令:"
            echo "curl -fsSL https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/main/install-online.sh | bash"
            exit 0
            ;;
    esac
    
    print_banner
    print_info "开始在线安装 Claude Config Switcher..."
    echo
    
    # 执行安装步骤
    check_requirements
    create_claude_dir
    download_ccs_files
    register_ccs_command
    create_sample_configs
    print_info "正在创建默认模板..."
    create_default_template
    print_info "正在验证安装..."
    
    print_info "开始验证安装结果..."
    if verify_installation; then
        print_success "验证通过！"
        show_next_steps
        
        # 提示用户如何使用
        echo
        print_success "安装完成！"
        print_info "要使用 CCS，请运行以下命令之一："
        echo
        print_color "$BOLD$WHITE" "  方法 1：重新加载 shell 配置并运行"
        print_color "$CYAN" "    source ~/${SHELL_RC_FILE##*/} && ccs"
        echo
        print_color "$BOLD$WHITE" "  方法 2：直接运行 CCS 脚本"
        print_color "$CYAN" "    $CCS_SCRIPT"
        echo
        print_color "$BOLD$WHITE" "  方法 3：重新打开终端窗口，然后运行"
        print_color "$CYAN" "    ccs"
        echo
        
        # 为当前终端会话创建临时 ccs 命令
        print_info "为当前终端会话创建临时 ccs 命令..."
        
        # 创建临时的 ccs 命令
        if [[ -x "$CCS_SCRIPT" ]]; then
            alias ccs="$CCS_SCRIPT"
            print_success "临时 ccs 命令已创建，可以直接运行 'ccs'"
            echo
            print_info "注意：这个临时命令只在当前终端会话中有效"
            print_info "重新打开终端后，请使用正常的 'ccs' 命令"
        fi
        
        echo
        # 只在终端环境下才显示询问
        if [[ -t 0 ]]; then
            read -rp "$(print_color "$BOLD$WHITE" "是否现在就启动 CCS? (Y/n): ")" start_now
        else
            start_now="n"
        fi
        
        if [[ ! "$start_now" =~ ^[Nn]$ ]]; then
            if [[ -x "$CCS_SCRIPT" ]]; then
                print_info "正在启动 CCS..."
                echo
                # 导出必要的环境变量
                export CLAUDE_DIR="$CLAUDE_DIR"
                export KEYS_FILE="$KEYS_FILE"
                export TEMPLATE_FILE="$TEMPLATE_FILE"
                # 直接运行 CCS 脚本
                exec "$CCS_SCRIPT"
            else
                print_error "CCS 脚本不可执行"
            fi
        else
            print_info "感谢使用 Claude Config Switcher！"
        fi
    else
        print_error "安装过程中出现问题"
        exit 1
    fi
}

# 运行主函数
main "$@"