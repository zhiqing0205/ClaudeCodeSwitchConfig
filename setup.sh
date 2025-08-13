#!/bin/bash

# =============================================================================
# Claude Config Switcher (CCS) 一键安装脚本
# 
# 功能：
# - 自动创建 ~/.claude 目录
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
REPO_URL="https://github.com/${GITHUB_USER}/ClaudeCodeSwitchConfig"

CLAUDE_DIR="${HOME}/.claude"
KEYS_FILE="${CLAUDE_DIR}/keys.conf"
CCS_SCRIPT="ccs"
BASHRC_FILE="${HOME}/.bashrc"

# 颜色和图标定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_title() {
    echo
    print_color "$BOLD$CYAN" "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "${BOLD}${CYAN}║${NC}${BOLD}%-78s${CYAN}║${NC}\n" "  $ICON_CLAUDE $SCRIPT_NAME 一键安装程序 v$VERSION"
    print_color "$BOLD$CYAN" "╚══════════════════════════════════════════════════════════════════════════════╝"
    print_color "$CYAN" "  GitHub: $REPO_URL"
    print_color "$CYAN" "  作者: $GITHUB_USER"
    echo
}

print_banner() {
    print_color "$BOLD$GREEN" "  ╔═══════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ║  $ICON_CLAUDE   Claude Config Switcher (CCS)   $ICON_CLAUDE                   ║"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ║     优雅管理多个 Claude API 配置，一键切换！                   ║"
    print_color "$BOLD$GREEN" "  ║                                                               ║"
    print_color "$BOLD$GREEN" "  ╚═══════════════════════════════════════════════════════════════╝"
}

# 检查系统要求
check_requirements() {
    print_info "检查系统要求..."
    
    # 检查 bash 版本
    if [[ "${BASH_VERSION%%.*}" -lt 4 ]]; then
        print_error "需要 Bash 4.0 或更高版本，当前版本: $BASH_VERSION"
        exit 1
    fi
    
    # 检查必要工具
    local tools=("awk" "grep" "sed")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_error "缺少必要工具: $tool"
            exit 1
        fi
    done
    
    # 检查ccs脚本文件
    if [[ ! -f "$CCS_SCRIPT" ]]; then
        print_error "找不到 CCS 脚本文件: $CCS_SCRIPT"
        print_info "请确保在包含 'ccs' 文件的目录中运行此安装脚本"
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

# 安装CCS命令
install_ccs_command() {
    print_info "安装 CCS 命令..."
    
    # 检查是否已经在bashrc中注册
    if grep -q "alias ccs=" "$BASHRC_FILE" 2>/dev/null; then
        print_warning "CCS 命令已在 ~/.bashrc 中注册"
        read -rp "是否重新安装? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "跳过 CCS 命令安装"
            return 0
        fi
        
        # 移除旧的alias
        sed -i '/alias ccs=/d' "$BASHRC_FILE"
        print_info "已移除旧的 CCS 命令注册"
    fi
    
    # 获取ccs脚本的绝对路径
    local ccs_path
    ccs_path=$(realpath "$CCS_SCRIPT")
    
    # 确保文件可执行
    chmod +x "$ccs_path"
    
    # 添加alias到bashrc
    echo "" >> "$BASHRC_FILE"
    echo "# Claude Config Switcher (CCS) - Auto-generated by installer" >> "$BASHRC_FILE"
    echo "# GitHub: $REPO_URL" >> "$BASHRC_FILE"
    echo "alias ccs='$ccs_path'" >> "$BASHRC_FILE"
    echo "" >> "$BASHRC_FILE"
    
    print_success "CCS 命令已注册到 ~/.bashrc"
    print_info "CCS 脚本位置: $ccs_path"
}

# 创建示例配置
create_sample_configs() {
    print_info "创建示例配置..."
    
    if [[ -s "$KEYS_FILE" ]]; then
        print_info "配置文件已有内容，跳过示例配置创建"
        return 0
    fi
    
    # 询问是否创建示例配置
    read -rp "是否创建示例配置? (Y/n): " create_sample
    if [[ "$create_sample" =~ ^[Nn]$ ]]; then
        print_info "跳过示例配置创建"
        return 0
    fi
    
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

# 验证安装
verify_installation() {
    print_info "验证安装..."
    
    # 检查bashrc中的alias
    if ! grep -q "alias ccs=" "$BASHRC_FILE" 2>/dev/null; then
        print_error "CCS 命令未正确注册到 ~/.bashrc"
        return 1
    fi
    
    # 检查ccs脚本是否可执行
    local ccs_path
    ccs_path=$(realpath "$CCS_SCRIPT")
    if [[ ! -x "$ccs_path" ]]; then
        print_error "CCS 脚本不可执行: $ccs_path"
        return 1
    fi
    
    # 检查目录和文件
    if [[ ! -d "$CLAUDE_DIR" ]] || [[ ! -f "$KEYS_FILE" ]]; then
        print_error "Claude 配置目录或文件不存在"
        return 1
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
    print_color "$BOLD$WHITE" "  下一步操作："
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$YELLOW" "  1. 重新加载 shell 配置："
    print_color "$WHITE" "     source ~/.bashrc"
    echo
    print_color "$YELLOW" "  2. 开始使用 CCS："
    print_color "$WHITE" "     ccs              # 启动交互式菜单"
    print_color "$WHITE" "     ccs add          # 添加新的 API 配置"
    print_color "$WHITE" "     ccs list         # 查看所有配置"
    print_color "$WHITE" "     ccs help         # 查看帮助信息"
    echo
    print_color "$YELLOW" "  3. 编辑示例配置 (如果需要)："
    print_color "$WHITE" "     ccs edit official     # 编辑 official 配置"
    print_color "$WHITE" "     ccs edit custom       # 编辑 custom 配置"
    echo
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$WHITE" "  文件位置："
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$CYAN" "  配置目录: $CLAUDE_DIR"
    print_color "$CYAN" "  配置文件: $KEYS_FILE"
    print_color "$CYAN" "  CCS 脚本: $(realpath "$CCS_SCRIPT")"
    echo
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color "$BOLD$WHITE" "  项目信息："
    print_color "$BOLD$CYAN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    print_color "$CYAN" "  GitHub: $REPO_URL"
    print_color "$CYAN" "  作者: $GITHUB_USER"
    echo
    print_color "$BOLD$GREEN" "  感谢使用 Claude Config Switcher！$ICON_CLAUDE"
    echo
}

# 卸载函数
uninstall() {
    print_title
    print_warning "即将卸载 Claude Config Switcher (CCS)"
    echo
    
    read -rp "确认卸载? 这将移除命令注册但保留配置文件 (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "卸载已取消"
        exit 0
    fi
    
    # 从bashrc中移除alias
    if grep -q "alias ccs=" "$BASHRC_FILE" 2>/dev/null; then
        # 创建备份
        cp "$BASHRC_FILE" "${BASHRC_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        
        # 移除CCS相关行
        sed -i '/# Claude Config Switcher (CCS)/d' "$BASHRC_FILE"
        sed -i '/alias ccs=/d' "$BASHRC_FILE"
        sed -i '/# GitHub.*claude-config-switcher/d' "$BASHRC_FILE"
        
        # 清理多余的空行
        sed -i '/^$/N;/^\n$/d' "$BASHRC_FILE"
        
        print_success "已从 ~/.bashrc 中移除 CCS 命令注册"
        print_info "已创建 ~/.bashrc 备份"
    else
        print_info "未在 ~/.bashrc 中找到 CCS 注册"
    fi
    
    print_color "$GREEN" "CCS 命令注册已成功卸载"
    print_info "配置文件保留在: $CLAUDE_DIR"
    
    read -rp "是否也删除所有配置文件? (y/N): " confirm_config
    if [[ "$confirm_config" =~ ^[Yy]$ ]]; then
        rm -rf "$CLAUDE_DIR"
        print_success "配置文件已删除"
    fi
    
    print_info "请运行 'source ~/.bashrc' 或重新打开终端以使更改生效"
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
            print_title
            echo "用法: $0 [选项]"
            echo
            echo "选项:"
            echo "  --uninstall, -u    卸载 CCS"
            echo "  --help, -h         显示此帮助信息"
            echo
            echo "默认操作: 安装 Claude Config Switcher"
            exit 0
            ;;
    esac
    
    clear
    print_banner
    print_title
    
    print_info "开始安装 Claude Config Switcher..."
    echo
    
    # 执行安装步骤
    check_requirements
    create_claude_dir
    install_ccs_command
    create_sample_configs
    
    if verify_installation; then
        show_next_steps
    else
        print_error "安装过程中出现问题"
        exit 1
    fi
}

# 运行主函数
main "$@"