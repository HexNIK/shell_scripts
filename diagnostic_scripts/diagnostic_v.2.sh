#!/bin/bash

# Константы и настройки
#================= оформление =============================== #
ASCII_ART=(
" ██████╗ ██╗  ██╗██╗  ██╗███████╗██╗  ██╗ █████╗ ██╗  ██╗██████╗ "
"██╔═████╗╚██╗██╔╝██║  ██║██╔════╝██║  ██║██╔══██╗██║  ██║██╔══██╗"
"██║██╔██║ ╚███╔╝ ███████║█████╗  ███████║╚██████║███████║██████╔╝"
"████╔╝██║ ██╔██╗ ╚════██║██╔══╝  ╚════██║ ╚═══██║╚════██║██╔══██╗"
"╚██████╔╝██╔╝ ██╗     ██║███████╗     ██║ █████╔╝     ██║██████╔╝"
" ╚═════╝ ╚═╝  ╚═╝     ╚═╝╚══════╝     ╚═╝ ╚════╝     ╚═╝╚══════╝"
)

# Базовые варианты
OK="✅"          # Белая галочка на зеленом фоне
FAIL="❌"        # Красный крест
ERROR="⚠️"       # Красный восклицательный знак (или ⛔)
ATTENTION="🔔"   # Колокольчик

# Альтернативные варианты (более минималистичные)
OK_ALT="✔️"      # Простая галочка
FAIL_ALT="✘"     # Простой крест
ERROR_ALT="!"    # Восклицание в треугольнике
ATTENTION_ALT="⚡" # Молния

# Еще варианты для разнообразия
SUCCESS="🎉"     # Празднование
WARNING="🚨"     # Полицейская сирена
INFO="ℹ️"        # Информация
PROGRESS="🔄"    # Прогресс/загрузка
QUESTION="❓"    # Вопрос

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
# demo


#
#======================================================#
#

LOG_FILE="/var/log/net_diag.log"
DNS_SERVERS=("8.8.8.8" "1.1.1.1")
#INTERFACES=("venet0")
INTERFACES=("enp3s0")

# Настройки тестов
PING_COUNT=5
PONG_COUNT=5
ICMP_PACKETS=10
TEST_DURATION=5

# Сетевые настройки
IPV4_GATEWAYS=("10.0.0.1" "192.168.1.1" "192.168.5.1")
IPV6_GATEWAY="2001:4860:4860::8888"

# DNS и HTTP
HTTP_DOMAIN="ifconfig.me"

# Временные ограничения
TIMEOUT=5

# Тело скрипта
echo "${ASCII_ART[0]}"
echo "${ASCII_ART[1]}"
echo "${ASCII_ART[2]}"
echo "${ASCII_ART[3]}"
echo "${ASCII_ART[4]}"
echo "${ASCII_ART[5]}"

# Заголовок скрипта
echo "===🔔 СКРИПТ ДИАГНОСТИКИ СЕТИ ==="
echo "Начало работы: $(date)"
echo -n "Логирование в: ${LOG_FILE} "

# Проверка прав
if [ "$EUID" -ne 0 ]; then
    echo "🔔 Этот скрипт должен быть запущен от имени root."
    exit 1
else
    echo "✅"	
fi

# Тестирование функционирования интерфейсов
echo "===🔔 ТЕСТ СЕТЕВЫХ ИНТЕРФЕЙСОВ ==="
for interface in "${INTERFACES[@]}"; do
    echo -n "Проверка интерфейса: ${interface} "
    ip link show "${interface}" &>> "${LOG_FILE}"
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: интерфейс ${interface} недоступен."
        exit 1
    else
        echo "✅"
    fi
done

# Тестирование DNS
echo "===🔔 ТЕСТ DNS ==="
for dns_server in "${DNS_SERVERS[@]}"; do
    echo -n "Проверка DNS-сервера: ${dns_server} "
    dig @${dns_server} example.com &>> "${LOG_FILE}"
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: DNS-сервер ${dns_server} недоступен."
        exit 1
    else
        echo "✅" 
    fi
done

# Тестирование HTTP
echo "=== 🔔ТЕСТ HTTP ==="
echo -n "Проверка доступности HTTP-сервера: ${HTTP_DOMAIN}"
curl -I "http://${HTTP_DOMAIN}" &>> "${LOG_FILE}"
if [ $? -ne 0 ]; then
    echo "❌ Ошибка: HTTP-сервер ${HTTP_DOMAIN} недоступен."
    exit 1
else
    echo "✅" 
fi

# Тестирование IPv4 шлюзов
echo "===🔔 ТЕСТ IPv4 ШЛЮЗОВ ==="
for gateway in "${IPV4_GATEWAYS[@]}"; do
    echo -n "Проверка IPv4 шлюза: ${gateway} "
    ping -c 3 -W ${TIMEOUT} ${gateway} &>> "${LOG_FILE}"
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: IPv4 шлюз ${gateway} недоступен."
    else
        echo "✅" 
    fi
done

# Тестирование IPv6 (если есть поддержка)
if command -v ping6 &> /dev/null; then
    echo "=== 🔔 ТЕСТ IPV6 ШЛЮЗА ==="
    echo -n "Проверка IPv6 шлюза: ${IPV6_GATEWAY} "
    ping6 -c 3 -W ${TIMEOUT} ${IPV6_GATEWAY} &>> "${LOG_FILE}"
    if [ $? -ne 0 ]; then
        echo "❌ Ошибка: IPv6 шлюз ${IPV6_GATEWAY} недоступен."
    else
        echo "✅" 
    fi
fi

# Тестирование пакетов на TX
echo -n "===🔔 ТЕСТ ПАКЕТОВ НА TX === "
TX_BEFORE=$(ip -s link show ${INTERFACES[0]} | awk 'NR==4 {print $3}')
sleep 1
TX_AFTER=$(ip -s link show ${INTERFACES[0]} | awk 'NR==4 {print $3}')

if [ $TX_AFTER -gt $TX_BEFORE ]; then
    echo "✅ Ok! Пакеты УХОДЯТ с интерфейса (TX вырос на $((TX_AFTER - TX_BEFORE)))"
else
    echo "❌ Fail! Пакеты НЕ УХОДЯТ с интерфейса (TX не изменился)"
fi

# Завершение скрипта
separator
echo "===👽 СКРИПТ ЗАВЕРШЕН ==="
echo "Дата завершения: $(date)"
