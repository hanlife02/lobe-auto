# LobeChat 部署工具

用于简化LobeChat的部署和管理的命令行工具。

## 安装

### 方法1: 一键安装

```bash
curl -fsSL https://example.com/install.sh | bash
```

### 方法2: 手动安装

```bash
git clone https://github.com/example/lobe-deploy.git
cd lobe-deploy
chmod +x install.sh
sudo ./install.sh
```

## 基本用法

```bash
lobe-deploy <命令> [选项]
```

## 可用命令

- `domain` - 使用域名模式部署
- `ip` - 使用IP模式部署
- `local` - 使用本地开发模式部署
- `logs` - 查看部署日志
- `version` - 显示版本信息
- `help` - 显示帮助信息

## 部署示例

### 域名模式部署

```bash
# 编辑配置
nano /usr/local/lib/lobe-deploy/etc/deploy.conf

# 部署
lobe-deploy domain
```

### IP模式部署

```bash
# 使用指定IP部署
lobe-deploy ip --ip 192.168.1.100 --port 8080
```

### 本地开发模式

```bash
lobe-deploy local --port 3000
```

## 日志查看

```bash
# 查看最新部署日志
lobe-deploy logs

# 查看错误日志
lobe-deploy logs error

# 查看最近50行日志
lobe-deploy logs 50
```

## 配置文件

配置文件位置: `/usr/local/lib/lobe-deploy/etc/deploy.conf`

首次运行任何命令时会自动从模板创建配置文件。



# else

使用说明
下载完整代码包并解压:

```
mkdir lobe-deploy
cd lobe-deploy
# 复制上面提供的所有文件到对应目录
```

设置执行权限:

```
chmod +x bin/lobe-deploy lib/*.sh install.sh
```

安装:

```
sudo ./install.sh
```

使用:

```
# 编辑配置
sudo nano /usr/local/lib/lobe-deploy/etc/deploy.conf

# 执行部署
lobe-deploy domain  # 域名模式
lobe-deploy ip      # IP模式
lobe-deploy local   # 本地模式

# 查看日志
lobe-deploy logs    # 查看最近部署日志
```