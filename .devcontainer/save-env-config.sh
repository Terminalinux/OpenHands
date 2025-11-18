#!/bin/bash

# Добавить в ~/.bashrc или ~/.zshrc для автозагрузки

# Функция для быстрого сохранения всех изменений
save() {
    cd /workspaces/OpenHands
    
    if [ -z "$(git status --porcelain)" ]; then
        echo "✓ Нет изменений для сохранения"
        return 0
    fi
    
    git add -A
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "Manual save: $TIMESTAMP" --quiet
    
    if git push origin HEAD:main --quiet 2>/dev/null; then
        echo "✓ Изменения сохранены в репозитории"
    else
        echo "⚠ Коммит создан, но push не удался (проверьте интернет)"
    fi
}

# Функция для проверки статуса
git-status-quick() {
    cd /workspaces/OpenHands
    git status --short
}

# Экспортируем функции
export -f save
export -f git-status-quick
