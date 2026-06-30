#!/bin/bash
# Creator OS — Codex 启动脚本
# 用法：chmod +x start-codex.sh && ./start-codex.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  🧠 Creator OS — 启动 Codex"
echo "  项目目录：$SCRIPT_DIR"
echo ""

# 数据保存在项目内的 data 目录（兼容 Codex 沙盒的 workspace-write 模式）
export CREATOR_OS_DATA_DIR="$SCRIPT_DIR/data"

echo "  📁 数据目录：$CREATOR_OS_DATA_DIR"
echo "  🔓 模式：workspace-write（安全模式，允许写入项目目录）"
echo ""

# 以 workspace-write 模式启动
codex -s workspace-write -a on-request -C "$SCRIPT_DIR"
