# NodeQuality 代理启动脚本

一个轻量级的 Bash 脚本，用于通过代理或 GitHub 镜像启动 NodeQuality，解决网络访问问题。

## ✨ 特性

- 🚀 **极简设计** - 仅 50 行代码，零依赖
- 🔒 **安全可靠** - 自动验证代理/镜像可用性
- 🌍 **多种方式** - 支持 HTTP/SOCKS5 代理、GitHub 镜像、直连
- ⚡ **即开即用** - 单命令启动，支持参数和环境变量
- 🔧 **灵活配置** - 自定义代理地址或镜像服务

## 🚀 快速开始

### 一键下载并运行

```bash
# 使用 GitHub 镜像（推荐国内用户）
curl -fsSL https://raw.githubusercontent.com/zensea/nodequality-proxy/main/nodequality-proxy.sh | bash -s ghproxy

# 使用本地代理
curl -fsSL https://raw.githubusercontent.com/zensea/nodequality-proxy/main/nodequality-proxy.sh | bash -s proxy http://127.0.0.1:7890

# 直接连接
curl -fsSL https://raw.githubusercontent.com/zensea/nodequality-proxy/main/nodequality-proxy.sh | bash
```

**国内用户（如无法访问 GitHub）：**
```bash
# 使用 GitLab 镜像仓库
curl -fsSL https://gitlab.com/dabao/nodequality-proxy/-/raw/main/nodequality-proxy.sh | bash -s ghproxy
```

### 下载后使用

```bash
# 下载脚本（GitHub）
curl -fsSL https://raw.githubusercontent.com/zensea/nodequality-proxy/main/nodequality-proxy.sh -o nodequality-proxy.sh
chmod +x nodequality-proxy.sh

# 国内用户可使用 GitLab
# curl -fsSL https://gitlab.com/dabao/nodequality-proxy/-/raw/main/nodequality-proxy.sh -o nodequality-proxy.sh

# 运行
./nodequality-proxy.sh ghproxy
```

## 📖 使用方法

### 方式 1: GitHub 镜像加速

```bash
# 使用默认镜像 (https://ghproxy.net/)
bash nodequality-proxy.sh ghproxy

# 使用自定义镜像
bash nodequality-proxy.sh ghproxy https://wget.la
bash nodequality-proxy.sh ghproxy https://hk.gh-proxy.com
```

**常用 GitHub 镜像列表：**
> 以下镜像，除 `ghproxy.net` 外均未测试可用性
- `https://ghproxy.net/` - Ghproxy (推荐)
- `https://wget.la/` - Ghproxy 备用
- `https://hk.gh-proxy.com/` - 另一个镜像服务

### 方式 2: HTTP/SOCKS5 代理

```bash
# 使用 HTTP 代理
bash nodequality-proxy.sh proxy http://127.0.0.1:7890

# 使用 SOCKS5 代理
bash nodequality-proxy.sh proxy socks5://127.0.0.1:1080

# 或通过环境变量
export PROXY="http://127.0.0.1:7890"
bash nodequality-proxy.sh proxy
```

### 方式 3: 直接连接

```bash
bash nodequality-proxy.sh
```

### 方式 4: 环境变量（适用于自动化）

```bash
# 设置环境变量
export MIRROR="https://ghproxy.net/"
export PROXY="http://127.0.0.1:7890"

# 直接运行
bash nodequality-proxy.sh
```

## 🔍 工作原理

1. **代理验证** - 通过 `google.com` 验证代理连通性（5秒超时）
2. **镜像验证** - 通过访问 NodeQuality README 验证镜像可用性
3. **脚本下载** - 从 GitHub 或镜像下载 NodeQuality 主脚本
4. **URL 替换** - 自动将脚本中的 GitHub URL 替换为镜像地址
5. **安全执行** - 临时文件权限 700，执行后自动清理

## 🛠️ 高级用法

### 调试模式

```bash
# 查看详细执行过程
bash -x nodequality-proxy.sh ghproxy
```

### 在脚本中使用

```bash
#!/bin/bash
# 自动化部署脚本

# 检测网络环境
if curl -s --connect-timeout 3 https://github.com >/dev/null 2>&1; then
    # 可以直连
    bash nodequality-proxy.sh
else
    # 使用镜像
    bash nodequality-proxy.sh ghproxy
fi
```

### 配置文件方式

```bash
# ~/.nodequality_config
export PROXY="http://127.0.0.1:7890"
export MIRROR="https://ghproxy.net/"

# 使用时
source ~/.nodequality_config
bash nodequality-proxy.sh
```

## 📋 命令参数

| 命令 | 参数 | 说明 | 示例 |
|------|------|------|------|
| `ghproxy` | `[镜像地址]` | 使用 GitHub 镜像，可选自定义地址 | `bash nodequality-proxy.sh ghproxy` |
| `proxy` | `<代理地址>` | 使用 HTTP/SOCKS5 代理（必需） | `bash nodequality-proxy.sh proxy http://127.0.0.1:7890` |
| `none` | - | 直接连接，不使用代理 | `bash nodequality-proxy.sh` |
| `help` | - | 显示帮助信息 | `bash nodequality-proxy.sh help` |

## ⚙️ 环境变量

| 变量 | 说明 | 示例 |
|------|------|------|
| `PROXY` | HTTP/SOCKS5 代理地址 | `export PROXY="http://127.0.0.1:7890"` |
| `MIRROR` | GitHub 镜像地址 | `export MIRROR="https://ghproxy.net/"` |

## ❓ 常见问题

### Q: 代理验证失败怎么办？

```bash
# 检查代理是否正确启动
curl -v -x http://127.0.0.1:7890 https://www.google.com

# 或跳过验证（不推荐）
# 手动编辑脚本，注释掉验证部分
```

### Q: 镜像验证失败怎么办？

```bash
# 尝试其他镜像
bash nodequality-proxy.sh ghproxy https://wget.la

# 或使用代理方式
bash nodequality-proxy.sh proxy http://127.0.0.1:7890
```

### Q: 如何添加自己的镜像服务？

```bash
# 直接指定镜像 URL
bash nodequality-proxy.sh ghproxy https://your-mirror.com/

# 镜像格式要求: 在原 URL 前加前缀
# 原始: https://raw.githubusercontent.com/user/repo/file
# 镜像: https://your-mirror.com/https://raw.githubusercontent.com/user/repo/file
```

### Q: 支持哪些操作系统？

- ✅ Linux (所有发行版)
- ✅ macOS (Intel & Apple Silicon)
- ✅ Windows (WSL, Git Bash, Cygwin)
- ✅ BSD 系统

### Q: 最低依赖要求？

- `bash` 3.0+
- `curl`
- `sed`

## 🔒 安全说明

1. **临时文件安全** - 使用 `chmod 700` 限制权限
2. **自动清理** - 通过 `trap` 确保临时文件自动删除
3. **验证机制** - 执行前验证代理/镜像可用性
4. **错误退出** - 使用 `set -e` 确保异常时立即停止

## 📝 脚本源码

查看完整源码: [nodequality-proxy.sh](nodequality-proxy.sh)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🔗 相关链接

- [本项目 GitHub 仓库](https://github.com/zensea/nodequality-proxy) ⭐
- [本项目 GitLab 镜像](https://gitlab.com/dabao/nodequality-proxy)
- [NodeQuality 官方仓库](https://github.com/LloydAsp/NodeQuality)

---

**⭐ 如果这个脚本对你有帮助，请给个 Star！**