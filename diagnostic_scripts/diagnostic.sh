#!/bin/bash
echo ""
echo " ██████╗ ██╗  ██╗██╗  ██╗███████╗██╗  ██╗ █████╗ ██╗  ██╗██████╗ "
echo "██╔═████╗╚██╗██╔╝██║  ██║██╔════╝██║  ██║██╔══██╗██║  ██║██╔══██╗"
echo "██║██╔██║ ╚███╔╝ ███████║█████╗  ███████║╚██████║███████║██████╔╝"
echo "████╔╝██║ ██╔██╗ ╚════██║██╔══╝  ╚════██║ ╚═══██║╚════██║██╔══██╗"
echo "╚██████╔╝██╔╝ ██╗     ██║███████╗     ██║ █████╔╝     ██║██████╔╝"
echo " ╚═════╝ ╚═╝  ╚═╝     ╚═╝╚══════╝     ╚═╝ ╚════╝      ╚═╝╚═════╝ "
echo "   


# Скрипт диагностики сети для OpenVZ VPS
# Запускать: bash ./diagnostic.sh | tee network-diag-$(date +%Y%m%d-%H%M%S).log

echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄" 
echo "▌                                                 ▐"
echo "▌ Диагностика сети...                             ▐"
echo "▌                                                 ▐"
echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"

echo " Сегодня: $(date)"

# Функция проверки наличия команды
check_cmd() {
    if ! command -v $1 &> /dev/null; then
        echo "Команда $1 не найдена (можно пропустить)"
        return 1
    fi
    return 0
}
# 1. System info
echo -e "\n[1] Информация о системе:"
uname -a
cat /etc/os-release | head -3

# 2. routing tables
echo -e "\n[2] Таблицы маршрутизации:"
echo "--- route -n ---"
route -n
echo -e "\n--- ip route show ---"
ip route show
#3. checking connectivity
echo -e "\n[3] Проверка связности:"
echo "--- ping 8.8.8.8 (4 пакета) ---"
ping -c 4 -W 2 8.8.8.8

echo -e "\n--- ping шлюза (если известен) ---"
for gw in 217.107.219.1 217.107.219.254 10.100.0.1 10.100.17.1; do
    echo "Пинг $gw:"
    ping -c 2 -W 1 $gw 2>/dev/null | grep -E "statistics|packet loss|time=" || echo "   не отвечает"
done

# 4. Firewall
echo -e "\n[4] Правила iptables:"
echo "--- iptables-legacy ---"
iptables-legacy -L -v -n 2>/dev/null || echo "iptables-legacy не активен"
echo -e "\n--- iptables (nft) ---"
iptables -L -v -n

# 5. Tracing
echo -e "\n[5] Трассировка:"
if check_cmd traceroute; then
    echo "--- traceroute to 8.8.8.8 ---"
    timeout 15 traceroute -n -w 2 8.8.8.8
else
    echo "traceroute не установлен"
fi

if check_cmd mtr; then
    echo -e "\n--- mtr report (4 пакета) ---"
    timeout 10 mtr -n -c 4 -r 8.8.8.8
else
    echo "mtr не установлен"
fi

# 6. routing details
echo -e "\n[6] Детальная маршрутизация:"
echo "--- ip route get 8.8.8.8 ---"
ip route get 8.8.8.8
echo -e "\n--- ip neigh show ---"
ip neigh show

# 7. interface statistics
echo -e "\n[7] Статистика интерфейса venet0:"
echo "--- Статистика ДО тестов ---"
ip -s link show venet0

# save TX counter points for analyze
TX_BEFORE=$(ip -s link show venet0 | grep -A 2 "venet0" | grep "TX" -A 1 | tail -1 | awk '{print $1}')

# 8. Num packets test
echo -e "\n[8] Отправка тестовых пакетов:"
echo "--- Запускаем ping (5 пакетов) ---"
ping -c 5 -W 1 8.8.8.8

echo -e "\n--- Статистика ПОСЛЕ ping ---"
ip -s link show venet0
TX_AFTER=$(ip -s link show venet0 | grep -A 2 "venet0" | grep "TX" -A 1 | tail -1 | awk '{print $1}')

echo -e "\n--- Изменение TX счетчика: $((TX_AFTER - TX_BEFORE)) пакетов ---"

# 9. DNS tests
echo -e "\n[9] Проверка DNS:"
if check_cmd nslookup; then
    echo "--- nslookup ya.ru 8.8.8.8 ---"
    timeout 5 nslookup ya.ru 8.8.8.8
else
    echo "nslookup не установлен"
fi

if check_cmd dig; then
    echo -e "\n--- dig @8.8.8.8 ya.ru ---"
    timeout 5 dig @8.8.8.8 ya.ru +short
else
    echo "dig не установлен"
fi

# 10. HTTP test
echo -e "\n[10] HTTP проверка:"
if check_cmd curl; then
    echo "--- curl http://8.8.8.8 ---"
    timeout 5 curl -I --interface venet0 http://8.8.8.8 2>/dev/null | head -10 || echo "HTTP тест не прошел"
else
    echo "curl не установлен"
fi

# 11. tcpdump (short)
echo -e "\n[11] Анализ трафика (tcpdump на 5 секунд):"
if check_cmd tcpdump; then
    echo "Запись ICMP пакетов на venet0 (5 сек)..."
    # Запускаем tcpdump на 5 секунд в foreground
    timeout 5 tcpdump -i venet0 -n icmp -c 10 -v 2>&1 | head -20
else
    echo "tcpdump не установлен"
fi

# 12. IPv6 diagnostics
echo -e "\n[12] IPv6 проверка:"
echo "--- ping6 8.8.8.8 (IPv4 адрес не пройдет, тест корректности) ---"
ping6 -c 2 -W 2 2001:4860:4860::8888 2>&1 | head -6 || echo "IPv6 ping не работает"

echo -e "\n--- ip -6 route get 2001:4860:4860::8888 ---"
ip -6 route get 2001:4860:4860::8888 2>/dev/null || echo "IPv6 маршрут не найден"

# 13. interfaces parameters
echo -e "\n[13] Детали интерфейса и sysctl:"
echo "--- ip -d addr show venet0 ---"
ip -d addr show venet0

echo -e "\n--- sysctl параметры ---"
sysctl -n net.ipv4.conf.venet0.rp_filter 2>/dev/null || echo "rp_filter: N/A"
sysctl -n net.ipv4.conf.venet0.accept_local 2>/dev/null || echo "accept_local: N/A"
sysctl -n net.ipv4.conf.venet0.forwarding 2>/dev/null || echo "forwarding: N/A"

# 14. Logs
echo -e "\n[14] Последние сообщения в логах:"
echo "--- dmesg (последние 20 строк) ---"
dmesg -T 2>/dev/null | tail -20 | grep -E 'venet|network|ufw|eth|veth' || echo "Нет записей в dmesg"

echo -e "\n--- syslog (последние 20 строк) ---"
if [ -f /var/log/syslog ]; then
    tail -20 /var/log/syslog 2>/dev/null | grep -E 'venet|network|kernel|ufw' || echo "Нет записей в syslog"
else
    echo "/var/log/syslog не найден"
fi

# 15. Results
echo -e "\n=================================================="
echo "ИТОГОВЫЙ АНАЛИЗ:"
echo "=================================================="

if [ $TX_AFTER -gt $TX_BEFORE ]; then
    echo "Ok! Пакеты УХОДЯТ с интерфейса (TX вырос на $((TX_AFTER - TX_BEFORE)))"
else
    echo "Fail! Пакеты НЕ УХОДЯТ с интерфейса (TX не изменился)"
fi

echo "=================================================="
echo "Скрипт завершен. Дата: $(date)"
echo "=================================================="
