#!/bin/bash
# LobeChat 部署工具安装脚本

# 设置颜色
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

# 设置安装目录
INSTALL_DIR="/usr/local/lib/lobe-deploy"
BIN_DIR="/usr/local/bin"

echo -e "${GREEN}开始安装 LobeChat 部署工具...${NC}"

# 创建目录结构
echo "创建目录结构..."
sudo mkdir -p "${INSTALL_DIR}"/{bin,lib,etc,logs}

# 复制文件
echo "复制文件..."
sudo cp -r bin/* "${INSTALL_DIR}/bin/"
sudo cp -r lib/* "${INSTALL_DIR}/lib/"
sudo cp -r etc/* "${INSTALL_DIR}/etc/"

# 创建符号链接
echo "创建命令链接..."
sudo ln -sf "${INSTALL_DIR}/bin/lobe-deploy" "${BIN_DIR}/lobe-deploy"

# 设置权限
echo "设置权限..."
sudo chmod +x "${INSTALL_DIR}/bin/lobe-deploy"
sudo chmod +x "${INSTALL_DIR}/lib/"*.sh
sudo chmod -R 755 "${INSTALL_DIR}"

echo -e "${GREEN}LobeChat 部署工具安装成功!${NC}"
echo -e "使用方法: lobe-deploy [命令]"
echo -e "帮助信息: lobe-deploy help"