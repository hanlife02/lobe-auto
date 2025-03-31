#!/bin/bash
# LobeChat 部署工具公共函数库

# 全局变量
DEPLOY_HOME=$(cd "$(dirname "$0")/.." && pwd)
LOG_DIR="${DEPLOY_HOME}/logs"

# 初始化日志系统
init_logging() {
    # 确保日志目录存在
    mkdir -p "${LOG_DIR}"
    
    # 创建日志文件
    LOG_FILE="${LOG_DIR}/deploy-$(date +%Y%m%d-%H%M%S).log"
    ERROR_FILE="${LOG_DIR}/deploy-error-$(date +%Y%m%d-%H%M%S).log"
    
    # 日志轮转（保留最近10个日志文件）
    local log_files_count=$(ls -l "${LOG_DIR}"/deploy-*.log 2>/dev/null | wc -l)
    local error_files_count=$(ls -l "${LOG_DIR}"/deploy-error-*.log 2>/dev/null | wc -l)
    
    if [ "$log_files_count" -gt 10 ]; then
        ls -t "${LOG_DIR}"/deploy-*.log | tail -n +11 | xargs -r rm
    fi
    
    if [ "$error_files_count" -gt 10 ]; then
        ls -t "${LOG_DIR}"/deploy-error-*.log | tail -n +11 | xargs -r rm
    fi
    
    # 重定向输出
    exec > >(tee -a "${LOG_FILE}") 2> >(tee -a "${ERROR_FILE}" >&2)
}

# 日志函数
log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # 根据日志级别设置颜色
    case "$level" in
        "INFO") local color="\033[0;32m" ;;
        "WARN") local color="\033[0;33m" ;;
        "ERROR") local color="\033[0;31m" ;;
        "DEBUG") local color="\033[0;34m" ;;
        *) local color="\033[0m" ;;
    esac
    
    # 输出彩色日志到终端
    echo -e "${color}[${timestamp}] [${level}] ${message}\033[0m"
    
    # 无颜色日志到文件
    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
    
    # 错误日志单独记录
    if [ "$level" = "ERROR" ]; then
        echo "[${timestamp}] [${level}] ${message}" >> "${ERROR_FILE}"
    fi
}

# 错误处理
error_exit() {
    log "ERROR" "$1"
    exit 1
}

# 检查命令是否存在
check_command() {
    if ! command -v "$1" &>/dev/null; then
        error_exit "命令未找到: $1，请先安装"
    fi
}

# 验证配置
validate_config() {
    log "DEBUG" "验证配置..."
    
    # 验证通用配置
    [ -z "$DEPLOY_MODE" ] && error_exit "部署模式未设置"
    
    # 根据部署模式验证配置
    case "$DEPLOY_MODE" in
        "domain")
            [ -z "$LOBE_DOMAIN" ] && error_exit "LobeChat 域名未设置"
            [ -z "$MINIO_DOMAIN" ] && error_exit "MinIO 域名未设置"
            [ -z "$CASDOOR_DOMAIN" ] && error_exit "Casdoor 域名未设置"
            ;;
        "ip")
            [ -z "$SERVER_IP" ] && error_exit "服务器IP未设置"
            ;;
        "local")
            # 本地模式无需额外验证
            ;;
        *)
            error_exit "无效的部署模式: $DEPLOY_MODE"
            ;;
    esac
    
    log "INFO" "配置验证通过"
}

# 生成随机密钥
generate_secret() {
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32
}

# 检查必要的依赖
check_dependencies() {
    log "INFO" "检查系统依赖..."
    
    # 基本依赖
    check_command docker
    check_command docker-compose
    check_command curl
    check_command openssl
    
    log "INFO" "系统依赖检查通过"
}