#!/bin/bash

# Daemon для автоматического сохранения изменений каждые 5 минут
# Запускается в фоне при старте codespace

REPO_DIR="/workspaces/OpenHands"
LOG_FILE="${HOME}/.openhands-auto-save.log"
INTERVAL=300  # 5 минут

echo "[$(date)] Starting auto-save daemon..." >> "$LOG_FILE"

while true; do
    sleep $INTERVAL
    
    cd "$REPO_DIR" 2>/dev/null || continue
    
    # Проверяем есть ли изменения
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        git add -A 2>/dev/null
        
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        if git commit -m "Auto-save: $TIMESTAMP" --quiet 2>/dev/null; then
            git push origin HEAD:main --quiet 2>/dev/null || echo "[$(date)] Push failed" >> "$LOG_FILE"
            echo "[$(date)] Auto-saved changes" >> "$LOG_FILE"
        fi
    fi
done
