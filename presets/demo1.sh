#!/bin/bash

ASCII_ART=(
" ██████╗ ██╗  ██╗██╗  ██╗███████╗██╗  ██╗ █████╗ ██╗  ██╗██████╗ "
"██╔═████╗╚██╗██╔╝██║  ██║██╔════╝██║  ██║██╔══██╗██║  ██║██╔══██╗"
"██║██╔██║ ╚███╔╝ ███████║█████╗  ███████║╚██████║███████║██████╔╝"
"████╔╝██║ ██╔██╗ ╚════██║██╔══╝  ╚════██║ ╚═══██║╚════██║██╔══██╗"
"╚██████╔╝██╔╝ ██╗     ██║███████╗     ██║ █████╔╝     ██║██████╔╝"
" ╚═════╝ ╚═╝  ╚═╝     ╚═╝╚══════╝     ╚═╝ ╚════╝     ╚═╝╚══════╝"
)

# ============================================
# Цвета для форматирования
# ============================================
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Основные цвета
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

# Яркие цвета
BRIGHT_RED="\033[1;31m"
BRIGHT_GREEN="\033[1;32m"
BRIGHT_YELLOW="\033[1;33m"
BRIGHT_BLUE="\033[1;34m"
BRIGHT_MAGENTA="\033[1;35m"
BRIGHT_CYAN="\033[1;36m"
BRIGHT_WHITE="\033[1;37m"

# ============================================
# Эмодзи для статусов
# ============================================
EMOJI_OK="✅"
EMOJI_FAIL="❌"
EMOJI_ERROR="⚠️"
EMOJI_ATTENTION="🔔"
EMOJI_INFO="ℹ️"
EMOJI_SUCCESS="🎉"
EMOJI_WARNING="🚨"
EMOJI_QUESTION="❓"
EMOJI_PROGRESS="🔄"

# ============================================
# Функции для вывода сообщений
# ============================================

# banner

banner() {
    echo "${ASCII_ART[0]}"
    echo "${ASCII_ART[1]}"
    echo "${ASCII_ART[2]}"
    echo "${ASCII_ART[3]}"
    echo "${ASCII_ART[4]}"
    echo "${ASCII_ART[5]}"

}

# Успешное сообщение
ok() {
    echo -e "${BRIGHT_GREEN}${EMOJI_OK} $1${RESET}"
}

# Ошибка (не критическая)
fail() {
    echo -e "${BRIGHT_RED}${EMOJI_FAIL} $1${RESET}" >&2
}

# Критическая ошибка
error() {
    echo -e "${BRIGHT_RED}${BOLD}${EMOJI_ERROR} ERROR: $1${RESET}" >&2
    exit 1
}

# Предупреждение
warn() {
    echo -e "${BRIGHT_YELLOW}${EMOJI_WARNING} $1${RESET}"
}

# Внимание/важное сообщение
attention() {
    echo -e "${BRIGHT_MAGENTA}${BOLD}${EMOJI_ATTENTION} $1${RESET}"
}

# Информационное сообщение
info() {
    echo -e "${BRIGHT_CYAN}${EMOJI_INFO} $1${RESET}"
}

# Вопрос с ожиданием ответа
question() {
    echo -e "${BRIGHT_YELLOW}${EMOJI_QUESTION} $1${RESET}"
    read -r response
    echo "$response"
}

# Прогресс/выполнение
progress() {
    echo -e "${BRIGHT_BLUE}${EMOJI_PROGRESS} $1${RESET}"
}

# Успешное завершение с празднованием
success() {
    echo -e "${BRIGHT_GREEN}${BOLD}${EMOJI_SUCCESS} $1${RESET}"
}

# Разделитель
separator() {
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

# Заголовок секции
header() {
    echo ""
    separator
    echo -e "${BRIGHT_WHITE}${BOLD}  $1${RESET}"
    separator
    echo ""
}

# ============================================
# Пример использования
# ============================================

# Пример функции для демонстрации
demo() {
    banner	
    header "Демонстрация работы функций"

    info "Начинаем установку пакетов..."
    progress "Загрузка данных..."
    sleep 1
    ok "Пакет успешно установлен"
    
    warn "Обнаружена устаревшая версия"
    attention "Требуется обновление системы"
    
    question "Продолжить обновление? (y/n)"
    
    # Имитация ошибки (закомментировано, чтобы скрипт не завершался)
    # error "Критическая ошибка: файл не найден"
    
    success "Все операции выполнены успешно!"
}

# Раскомментируйте для запуска демо
 demo

