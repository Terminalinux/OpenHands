#!/bin/bash
# Постоянная настройка автосохранения при создании codespace

set -e

# Настройка git для автопуша
git config --global credential.helper store

# Добавляем alias для быстрого автосохранения
git config alias.autosave '!bash .githooks/auto-save.sh'

# Настраиваем pre-commit hook для автокоммита перед отключением
mkdir -p .git/hooks

cat > .git/hooks/pre-push << 'HOOK'
#!/bin/bash
# Убедиться, что все файлы сохранены перед push

if [ -z "$GIT_SKIP_AUTOSAVE" ]; then
    git add -A 2>/dev/null || true
    if ! git diff-index --quiet HEAD --; then
        git commit -m "Auto-save before push: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
    fi
fi
HOOK

chmod +x .git/hooks/pre-push

echo "✓ Auto-save настроен"
