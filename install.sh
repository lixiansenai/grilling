#!/usr/bin/env bash
# 安装 grilling skill 到本机已存在的 Agent Skills 目录。
# 用法：bash install.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/skills/grilling"

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "错误：找不到 $SRC/SKILL.md" >&2
  echo "请在仓库根目录运行本脚本。" >&2
  exit 1
fi

targets=()
for dir in "$HOME/.claude/skills" "$HOME/.workbuddy/skills"; do
  [ -d "$dir" ] && targets+=("$dir")
done

# 一个都没有时，默认装到 Claude Code 的位置
if [ ${#targets[@]} -eq 0 ]; then
  mkdir -p "$HOME/.claude/skills"
  targets=("$HOME/.claude/skills")
fi

for target in "${targets[@]}"; do
  dest="$target/grilling"
  mkdir -p "$dest"
  cp -f "$SRC/SKILL.md" "$dest/SKILL.md"
  echo "已安装：$dest/SKILL.md"
done

echo
echo "完成。重启会话后生效，试试对 AI 说「拷问我」。"
