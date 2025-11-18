#!/bin/bash

# Скрипт для автоматического сохранения изменений в git
# Выполняет коммит и push всех изменений

set -e

REPO_DIR="/workspaces/OpenHands"
cd "$REPO_DIR"

# Проверка наличия изменений
if git diff-index --quiet HEAD --; then
    exit 0
fi

# Добавляем все изменения (кроме ignored файлов)
git add -A

# Создаем коммит с временной меткой
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Auto-save: $TIMESTAMP" --quiet 2>/dev/null || true

# Пушим изменения
git push origin HEAD:main --quiet 2>/dev/null || true

echo "[$(date '+%H:%M:%S')] Changes auto-saved to repository"
