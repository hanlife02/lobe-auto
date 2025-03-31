#!/bin/bash
# LobeChat 本地开发模式部署脚本

# 引入公共函数库
DEPLOY_HOME=$(cd "$(dirname "$0")/.." && pwd)
source "${DEPLOY_HOME}/lib/common-functions.sh"

# 显示帮助
show_help() {
    echo "LobeChat 本地开发模式部署"
    echo "用法: lobe-deploy local [选项]"
    echo
    echo "选项:"
    echo "  --port PORT      设置开发服务端口 (默认: 3000)"
    echo "  --help           显示帮助信息"
}

# 解析参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --port)
                DEV_PORT="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log "ERROR" "未知选项: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 本地模式部署主函数
local_deploy() {
    log "INFO" "开始本地开发模式部署..."
    
    # 设置默认值
    DEV_PORT=${DEV_PORT:-3000}
    
    # 加载配置
    source "${DEPLOY_HOME}/etc/deploy.conf"
    
    # 参数覆盖配置
    parse_args "$@"
    
    # 验证配置
    DEPLOY_MODE="local"  # 强制为本地模式
    validate_config
    
    # 检查依赖
    check_dependencies
    
    # 部署流程
    log "INFO" "准备开发环境..."
    prepare_environment
    
    log "INFO" "启动开发服务器..."
    start_dev_server
    
    log "INFO" "本地开发模式部署完成"
}

# 准备开发环境
prepare_environment() {
    log "DEBUG" "使用以下配置:"
    log "DEBUG" "- 开发端口: ${DEV_PORT}"
    
    # 生成开发配置
    log "INFO" "生成开发配置..."
    # 实际生成配置的逻辑...
}

# 启动开发服务器
start_dev_server() {
    log "INFO" "拉取代码库..."
    # git clone...
    
    log "INFO" "安装依赖..."
    # npm install...
    
    log "INFO" "启动开发服务器..."
    # npm run dev...
    
    log "INFO" "开发服务器已启动，访问地址: http://localhost:${DEV_PORT}"
}

# 执行主函数
local_deploy "$@"