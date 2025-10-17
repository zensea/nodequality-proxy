#!/bin/bash
# NodeQuality 代理启动脚本
# 用法: bash nodequality-proxy.sh [ghproxy|proxy [地址]|none]

set -e  # 遇到错误立即退出

# 配置
PROXY="${PROXY:-}"                    # 设置代理: export PROXY="http://127.0.0.1:7890"
MIRROR="${MIRROR:-}"                  # 设置镜像: export MIRROR="https://ghproxy.net/"
RAW_URL="https://raw.githubusercontent.com/LloydAsp/NodeQuality/refs/heads/main/NodeQuality.sh"

# 规范化 URL（确保末尾有且只有一个斜杠）
normalize() { echo "${1%/}/"; }

# 预设处理
case "${1:-}" in
  ghproxy) MIRROR=$(normalize "${2:-https://ghproxy.net}") PROXY="" ;;
  proxy)   PROXY="${2:-$PROXY}"
           [ -z "$PROXY" ] && { echo "错误: bash $0 proxy <地址>"; exit 1; }
           MIRROR="" ;;
  none)    MIRROR="" PROXY="" ;;
  help|-h) echo "用法: bash $0 [ghproxy [镜像地址]|proxy <代理地址>|none]
示例:
  bash $0 ghproxy                              # 使用默认镜像
  bash $0 ghproxy https://wget.la   # 自定义镜像
  bash $0 proxy http://127.0.0.1:7890          # 使用代理"; exit 0 ;;
esac

# 应用并验证代理
ORIGINAL_HTTP_PROXY="${http_proxy:-}"
ORIGINAL_HTTPS_PROXY="${https_proxy:-}"

[ -n "$PROXY" ] && {
  export http_proxy="$PROXY" https_proxy="$PROXY"
  echo "✓ 代理: $PROXY"
  curl -sf --connect-timeout 5 --max-time 10 https://www.google.com >/dev/null || {
    echo "✗ 代理验证失败"; exit 1;
  }
  echo "  验证通过"
}

# 应用并验证镜像
[ -n "$MIRROR" ] && {
  echo "✓ 镜像: $MIRROR"
  TEST_URL="${MIRROR}https://raw.githubusercontent.com/LloydAsp/NodeQuality/refs/heads/main/README.md"
  curl -sfI --connect-timeout 5 --max-time 10 "$TEST_URL" >/dev/null || {
    echo "✗ 镜像验证失败"; exit 1;
  }
  echo "  验证通过"
}

# 下载脚本
TMP=$(mktemp) && chmod 700 "$TMP"

# 清理函数
cleanup_files() {
  rm -f "$TMP"
  http_proxy="$ORIGINAL_HTTP_PROXY"
  https_proxy="$ORIGINAL_HTTPS_PROXY"
}
trap cleanup_files EXIT

if [ -n "$MIRROR" ]; then
  # 使用镜像模式
  MIRROR="${MIRROR%/}/"  # 规范化
  echo "✓ 下载: 镜像模式"
  curl -sfL "${MIRROR}${RAW_URL}" -o "$TMP" || { echo "✗ 下载失败"; exit 1; }
  # 替换 GitHub URL
  sed -i"" "s|https://\(raw\.\)\?github\(usercontent\)\?.com/|${MIRROR}https://\1github\2.com/|g" "$TMP" 2>/dev/null ||
  sed -i '' "s|https://\(raw\.\)\?github\(usercontent\)\?.com/|${MIRROR}https://\1github\2.com/|g" "$TMP"
else
  # 直接连接模式，使用官方推荐地址
  echo "✓ 下载: 官方地址"
  curl -sfL "https://run.NodeQuality.com" -o "$TMP" || { echo "✗ 下载失败"; exit 1; }
fi

# 执行
bash "$TMP"