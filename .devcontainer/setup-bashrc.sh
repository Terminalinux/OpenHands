#!/bin/bash

# Добавить автосохранение в bashrc/zshrc

BASHRC_FILE="${HOME}/.bashrc"
ZSHRC_FILE="${HOME}/.zshrc"

ADD_TO_RC='
# OpenHands Auto-Save Functions
save() {
    cd /workspaces/OpenHands
    
    if [ -z "$(git status --porcelain)" ]; then
        echo "✓ Нет изменений для сохранения"
        return 0
    fi
    
    git add -A
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    git commit -m "Manual save: $TIMESTAMP" --quiet
    
    if git push origin HEAD:main --quiet 2>/dev/null; then
        echo "✓ Изменения сохранены в репозитории"
    else
        echo "⚠ Коммит создан, но push не удался"
    fi
}

git-status-quick() {
    cd /workspaces/OpenHands
    git status --short
}

alias gss="git-status-quick"
alias gps="save"
'

# Добавляем в bashrc если еще не добавлено
if [ -f "$BASHRC_FILE" ]; then
    if ! grep -q "OpenHands Auto-Save Functions" "$BASHRC_FILE"; then
        echo "$ADD_TO_RC" >> "$BASHRC_FILE"
        echo "✓ Добавлено в ~/.bashrc"
    fi
fi

# Добавляем в zshrc если существует
if [ -f "$ZSHRC_FILE" ]; then
    if ! grep -q "OpenHands Auto-Save Functions" "$ZSHRC_FILE"; then
        echo "$ADD_TO_RC" >> "$ZSHRC_FILE"
        echo "✓ Добавлено в ~/.zshrc"
    fi
fi
