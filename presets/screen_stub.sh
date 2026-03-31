#!/bin/bash

ASCII_ART=(
" ██████╗ ██╗  ██╗██╗  ██╗███████╗██╗  ██╗ █████╗ ██╗  ██╗██████╗ "
"██╔═████╗╚██╗██╔╝██║  ██║██╔════╝██║  ██║██╔══██╗██║  ██║██╔══██╗"
"██║██╔██║ ╚███╔╝ ███████║█████╗  ███████║╚██████║███████║██████╔╝"
"████╔╝██║ ██╔██╗ ╚════██║██╔══╝  ╚════██║ ╚═══██║╚════██║██╔══██╗"
"╚██████╔╝██╔╝ ██╗     ██║███████╗     ██║ █████╔╝     ██║██████╔╝"
" ╚═════╝ ╚═╝  ╚═╝     ╚═╝╚══════╝     ╚═╝ ╚════╝     ╚═╝╚══════╝"
)

# Цвета для оформления
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# banner

banner() {
    echo "${ASCII_ART[0]}"
    echo "${ASCII_ART[1]}"
    echo "${ASCII_ART[2]}"
    echo "${ASCII_ART[3]}"
    echo "${ASCII_ART[4]}"
    echo "${ASCII_ART[5]}"

}


digital_rain() {
    local duration=$1
    local end_time=$((SECONDS + duration))
    echo -e "${GREEN}[HASH_GEN_v.2] ${NC}"
    while [ $SECONDS -lt $end_time ]; do
        local line=""
        for ((i=0; i<$(tput cols 2>/dev/null || echo 80); i++)); do
            line+=$(printf "\\x$(printf "%x" $((RANDOM % 94 + 33)))")
        done
        echo -e "\033[32m$line\033[0m"
        sleep 0.1
    done | head -n $((duration * 10)) # Ограничиваем вывод
    echo -e "${GREEN}[HASH_GEN_v.2] Ok! ${NC}"
}

simulate() {
    local msg=$1
    local delay=${2:-1}
    echo -e "${CYAN}>>> $msg${NC}"
    for ((i=0; i<=100; i+=2)); do
        printf "\r${YELLOW}[%-10s] %d%%${NC}" "$(printf '#%.0s' $(seq 1 $((i/10))))" "$i"
        sleep 0.5
    done
    echo -e "\n${GREEN}✓ Готово.${NC}\n"
    sleep "$delay"
}

# Главный цикл
main_loop() {
    local iteration=1
    while true; do
        echo -e "${YELLOW}==================== ИТЕРАЦИЯ $iteration ====================${NC}\n"

        # 1. Клонирование репозитория
        simulate "git clone https://github.com/example/project.git" 1

        # 2. Сборка пакетов
        simulate "./configure && make && make install" 1

        # 3. Сборка Docker-контейнера
        simulate "docker build -t myapp:latest ." 1

        # 4. Запуск Docker-контейнера
        simulate "docker run -d --name myapp myapp:latest" 1

        # 5. Цифропад на 30 секунд
        digital_rain 30

        # 6. Показ дерева директории (tree)
        simulate "tree -L 2" 0.5
        echo -e "${CYAN}tree:${NC}"
        cat << 'EOF'
.
├── src/
│   ├── main.c
│   ├── utils.c
│   └── header.h
├── docs/
│   └── README.md
├── scripts/
│   └── build.sh
├── assets/
│   ├── img
│   ├── js
│   └── binary
├── dist/
│   ├── adapter.go
│   ├── mask.go
│   └── bridge.go
├── conf/
│   ├── mainconfig.conf
│   ├── utils.conf
├── data/
│   ├── main.db
│   ├── loft4j.bin
│   ├── trojan.exe.bin
│   ├── analizator.py
│   └── form_phish.py
└── Dockerfile
EOF
        echo ""

        simulate "git log --graph --oneline --all" 0.5
        echo -e "${CYAN}git log:${NC}"
        cat << 'EOF'
*   a1b2c3d (HEAD -> master) Merge branch 'feature-x'
|\
| * e4f5g6h (feature-x) Добавлен новый модуль
| * i7j8k9l (fix:) Исправление багов
* | m0n1o2p (save): Основной коммит
* | q3r4s5t (govnokod): Начальная реализация
|/
* u6v7w8x Первоначальный коммит
EOF
        echo ""

        digital_rain 5

        simulate "./program core.dump" 0.5
        echo -e "${CYAN}${NC}"
        cat << 'EOF'
(gdb) bt
#0  0x00000000004005a6 in main () at main.c:15
#1  0x00007ffff7a05b97 in __libc_start_main ()
(gdb) info registers
rax            0x0    0
rbx            0x4005a0 4195744
(gdb) q
EOF
        echo ""

        simulate "hexedit /proc/self/mem" 0.5
        echo -e "${CYAN}${NC}"
        echo "00000000  7F 45 4C 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|"
        echo "00000010  03 00 3E 00 01 00 00 00  [РЕДАКТИРОВАНО]  00 00 00  |..>.............|"
        echo -e "${YELLOW}[Пользователь изменил байты по смещению 0x0C]${NC}\n"

        simulate "nasm -f elf64 code.asm" 1
        echo -e "${CYAN}${NC}"
        cat << 'EOF'
section .text
    global _start
_start:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, 13
    syscall
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall
section .data
    msg db 'eval($"/usr/local/bin/hijack")', 0xa
EOF
        echo ""

        simulate "tcpdump -i eth0 -c 10" 1
        echo -e "${CYAN}tcpdump:${NC}"
        cat << 'EOF'
listening on wlo1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
12:07:54.411844 IP host-209.56378 > mc.yandex.ru.https: Flags [P.], seq 1115637171:1115637215, ack 702521554, win 501, length 44
12:07:54.413989 IP 5.45.76.168.2710 > host-209.51544: Flags [F.], seq 1550531834, ack 1309427427, win 331, length 0
12:07:54.414002 IP host-209.51544 > 5.45.76.168.2710: Flags [.], ack 1, win 2920, length 0
12:07:54.421812 IP mc.yandex.ru.https > host-209.56378: Flags [.], ack 44, win 166, length 0
12:07:54.432020 IP host-209.51705 > 85.175.199.178.51415: Flags [S], seq 3890070302, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.432056 IP host-209.50873 > 41.234.38.94.51415: Flags [S], seq 285565761, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.432067 IP host-209.33539 > net167.79.95-94.izhevsk.ertelecom.ru.51415: Flags [S], seq 4210369294, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.432077 IP host-209.38883 > customer-201-141-110-141.cablevision.net.mx.51415: Flags [S], seq 785048051, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.432087 IP host-209.36337 > 81.214.165.122.dynamic.ttnet.com.tr.51415: Flags [S], seq 1077633425, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.432097 IP host-209.44289 > 104.28.161.222.47287: Flags [S], seq 2011896751, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.466394 IP host-209.40686 > _gateway.domain: 14357+ PTR? 119.250.250.87.in-addr.arpa. (45)
12:07:54.560032 IP host-209.59793 > 104.28.212.75.48805: Flags [S], seq 3065708637, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.560067 IP host-209.60303 > client192-211.infolink.ru.51415: Flags [S], seq 3342212067, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.560079 IP host-209.49855 > 188.19.41.171.63800: Flags [S], seq 2903360181, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624045 IP host-209.56199 > 212.35.176.188.63150: Flags [S], seq 3196031037, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624083 IP host-209.51787 > 95-47-171-57.cgnat.rtatelecom.ru.49926: Flags [S], seq 1500307534, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624096 IP host-209.44105 > 87.225.9.168.51415: Flags [S], seq 2066516412, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624109 IP host-209.59347 > 177.84.245.148.51415: Flags [S], seq 2161838246, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624121 IP host-209.45577 > 213.152.161.58.51415: Flags [S], seq 2061656499, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624132 IP host-209.49857 > 188.163.38.66.22095: Flags [S], seq 2703292214, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.624143 IP host-209.59469 > 86.106.84.167.34304: Flags [S], seq 3891497267, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.652731 IP host-209.51415 > 212.35.185.118.63150: UDP, length 20
12:07:54.652776 IP host-209.51415 > 46.232.211.163.51415: UDP, length 20
12:07:54.652959 IP host-209.56687 > 138.94.86.106.18380: Flags [S], seq 2186292074, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.653160 IP host-209.43147 > 92.101.128.143.52928: Flags [S], seq 2083407389, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.653254 IP host-209.52485 > 46-110-206-112.plcsflad.metronetinc.net.51415: Flags [S], seq 219158770, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.653309 IP host-209.51415 > hfce-191-99-43-204.customer.claro.com.ec.51415: UDP, length 20
12:07:54.653328 IP host-209.51415 > m5-240-88-71.cust.tele2.lv.51417: UDP, length 20
12:07:54.653344 IP host-209.51415 > 212.104.214.2.12700: UDP, length 20
12:07:54.653420 IP host-209.43167 > 175.213.197.90.51415: Flags [S], seq 2518943598, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.653513 IP host-209.38765 > 183.241.166.179.51415: Flags [S], seq 2110314339, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.653565 IP host-209.51415 > 176.42.22.23.51415: UDP, length 20
12:07:54.653590 IP host-209.51415 > 195.138.233.98.51415: UDP, length 20
12:07:54.653662 IP host-209.57307 > ec2-54-92-204-93.compute-1.amazonaws.com.51919: Flags [S], seq 2861908430, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.660923 IP 5.45.76.168.2710 > host-209.51544: Flags [F.], seq 0, ack 1, win 331, length 0
12:07:54.660972 IP host-209.51544 > 5.45.76.168.2710: Flags [.], ack 1, win 2920, options [nop,nop,sack 1 {0:1}], length 0
12:07:54.674408 IP host-209.51415 > statsclient06.soervice.com.25999: UDP, length 20
12:07:54.674429 IP host-209.51415 > 104.28.198.245.40321: UDP, length 20
12:07:54.674440 IP host-209.51415 > 188.163.16.192.63912: UDP, length 20
12:07:54.714689 IP 46.232.211.163 > host-209: ICMP 46.232.211.163 udp port 51415 unreachable, length 56
12:07:54.800653 IP api.browser.yandex.net.https > host-209.43180: Flags [.], ack 47429537, win 166, length 0
12:07:54.800702 IP host-209.43180 > api.browser.yandex.net.https: Flags [.], ack 1, win 501, length 0
12:07:54.813966 IP 5.45.76.168.2710 > host-209.34236: Flags [F.], seq 1601277121, ack 1230915643, win 331, length 0
12:07:54.814035 IP host-209.34236 > 5.45.76.168.2710: Flags [.], ack 1, win 2920, options [nop,nop,sack 1 {0:1}], length 0
12:07:54.944030 IP host-209.41391 > 188-115-141-66.broadband.tenet.odessa.ua.15430: Flags [S], seq 3354128137, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:07:54.946360 IP 5.45.76.168.2710 > host-209.51544: Flags [F.], seq 0, ack 1, win 331, length 0
12:07:54.946421 IP host-209.51544 > 5.45.76.168.2710: Flags [.], ack 1, win 2920, options [nop,nop,sack 1 {0:1}], length 0
12:07:54.995515 IP host-209.52518 > mc.yandex.ru.https: Flags [P.], seq 3928642983:3928643027, ack 2951365710, win 501, length 44
12:07:55.011836 IP mc.yandex.ru.https > host-209.52518: Flags [.], ack 44, win 166, length 0
12:07:55.160032 IP host-209.51415 > 168-0-162-145.sejaamigo.com.br.51415: UDP, length 20
12:07:55.160080 IP host-209.51415 > 50.34.57.23.51415: UDP, length 20
12:07:55.160102 IP host-209.51415 > 62-112-10-81.hosted-by-worldstream.net.51415: UDP, length 20
12:07:55.160125 IP host-209.51415 > BC24E8B9.dsl.pool.telekom.hu.51415: UDP, length 20
12:07:55.160146 IP host-209.51415 > broadband-37-110-44-23.ip.moscow.rt.ru.51415: UDP, length 20
12:07:55.160161 IP host-209.51415 > 137.23.23.31.donpac.ru.59121: UDP, length 20
12:07:55.170251 IP host-209.51415 > 33b73257.skybroadband.com.51415: UDP, length 20
12:07:55.170276 IP host-209.51415 > 213.152.161.5.57286: UDP, length 20
12:07:55.170289 IP host-209.51415 > 60.188.114.190.1024: UDP, length 20
12:08:04.647352 IP host-209.60805 > _gateway.domain: 57173+ PTR? 75.212.28.104.in-addr.arpa. (44)
12:08:04.671453 IP host-209.51415 > 175.209.244.1.51415: UDP, length 20
12:08:04.671482 IP host-209.51415 > 91.235.88.40.52281: UDP, length 20
12:08:04.677222 IP _gateway.domain > host-209.60805: 57173 NXDomain 0/1/0 (106)
12:08:04.677223 IP _gateway.domain > host-209.60805: 57173 NXDomain 0/1/0 (106)
12:08:04.677469 IP host-209.57063 > _gateway.domain: 16018+ PTR? 211.192.123.93.in-addr.arpa. (45)
12:08:04.736779 IP stackoverflow.com.https > host-209.44402: Flags [P.], seq 1615810223:1615810277, ack 4151053753, win 16, length 54
12:08:04.737095 IP host-209.44402 > stackoverflow.com.https: Flags [P.], seq 1:33, ack 54, win 501, length 32
12:08:04.743327 IP stackoverflow.com.https > host-209.44402: Flags [.], ack 33, win 16, length 0
12:08:05.401880 IP host-209.57001 > _gateway.domain: 12424+ PTR? 188.176.35.212.in-addr.arpa. (45)
12:08:52.011091 IP host-209.59290 > _gateway.domain: 42686+ PTR? 128.38.111.172.in-addr.arpa. (45)
12:08:52.031004 IP host-209.46432 > 47.246.2.225.https: Flags [P.], seq 2726886728:2726887424, ack 1033212463, win 501, length 696
12:08:52.031022 IP host-209.46432 > 47.246.2.225.https: Flags [P.], seq 696:1933, ack 1, win 501, length 1237
12:08:52.038482 IP 47.246.2.225.https > host-209.46432: Flags [.], ack 696, win 186, length 0
12:08:52.039183 IP 47.246.2.225.https > host-209.46432: Flags [.], ack 1933, win 191, length 0
12:08:52.101487 IP host-209.34604 > mc.yandex.ru.https: Flags [P.], seq 3624601602:3624601647, ack 2195266194, win 501, length 45
12:08:52.110735 IP mc.yandex.ru.https > host-209.34604: Flags [.], ack 45, win 1289, length 0
12:09:02.697608 IP host-209.33277 > _gateway.domain: 63341+ PTR? 234.193.180.213.in-addr.arpa. (46)
12:09:02.783026 IP m5-240-108-140.cust.tele2.lv > host-209: ICMP m5-240-108-140.cust.tele2.lv udp port 51415 unreachable, length 56
12:09:02.970890 IP host-209.56682 > _gateway.domain: 58955+ PTR? 66.141.115.188.in-addr.arpa. (45)
12:09:03.302398 IP host-209.52284 > _gateway.domain: 54335+ PTR? 145.162.0.168.in-addr.arpa. (44)
12:09:03.304681 IP host-209.53842 > 155.212.204.133.https: Flags [P.], seq 573065832:573065876, ack 73916726, win 501, length 44
12:09:03.313427 IP 155.212.204.133.https > host-209.53842: Flags [P.], seq 1:41, ack 44, win 83, length 40
12:09:03.313446 IP host-209.53842 > 155.212.204.133.https: Flags [.], ack 41, win 501, length 0
12:09:03.360914 IP host-209.53229 > 18-199-91-188.ftth.glasoperator.nl.51415: Flags [S], seq 2984252720, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.360925 IP host-209.58657 > 185.141.234.236.20134: Flags [S], seq 2914397348, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.360928 IP host-209.43485 > 188.68.112.58.51415: Flags [S], seq 245554230, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.360930 IP host-209.41163 > host-213-78-140-236.as13285.net.51415: Flags [S], seq 1835668272, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.420447 IP host-209.51415 > 5x18x251x57.static-business.spb.ertelecom.ru.51415: UDP, length 20
12:09:03.420462 IP host-209.51415 > static-68-235-36-35.cust.tzulo.com.41424: UDP, length 20
12:09:03.420472 IP host-209.51415 > host72.186-12-171.telmex.net.ar.51415: UDP, length 20
12:09:03.420476 IP host-209.51415 > 31.43.214.148.30210: UDP, length 20
12:09:03.420510 IP host-209.53305 > 78.175.49.92.dynamic.ttnet.com.tr.34302: Flags [S], seq 3315608801, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.420543 IP host-209.40839 > 178.162.173.76.51415: Flags [S], seq 628755066, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.420565 IP host-209.33161 > 60.188.92.208.51415: Flags [S], seq 224668064, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.420576 IP host-209.51415 > 37.249.206.121.broad.np.fj.dynamic.163data.com.cn.2279: UDP, length 20
12:09:03.420582 IP host-209.51415 > 81.5.114.188.donpac.ru.59121: UDP, length 20
12:09:03.420596 IP host-209.43137 > c-68-41-165-124.hsd1.mi.comcast.net.51415: Flags [S], seq 3686731718, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.423941 IP host-209.46243 > a243.sub31.net78.udm.net.51415: Flags [S], seq 190363022, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.423949 IP host-209.55573 > 211.42.207.2.51415: Flags [S], seq 2452400154, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:03.471757 IP 178.162.173.76.51415 > host-209.40839: Flags [R.], seq 0, ack 628755067, win 0, length 0
12:09:18.283947 IP host-209.50037 > _gateway.domain: 15377+ PTR? 1.244.209.175.in-addr.arpa. (44)
12:09:20.155851 IP host-209.52788 > _gateway.domain: 41402+ PTR? 225.2.246.47.in-addr.arpa. (43)
12:09:20.168049 IP host-209.51415 > 5x167x59x229.dynamic.ulsk.ertelecom.ru.59285: UDP, length 541
12:09:20.169599 IP host-209.51415 > 66.99.248.110.1024: UDP, length 20
12:09:20.191953 IP host-209.56777 > 185.143.147.221.40360: Flags [S], seq 2701447502, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:20.211824 IP 5x167x59x229.dynamic.ulsk.ertelecom.ru.59285 > host-209.51415: UDP, length 20
12:09:20.217370 IP 5x167x59x229.dynamic.ulsk.ertelecom.ru.59285 > host-209.51415: UDP, length 516
12:09:20.220339 IP host-209.51415 > 5x167x59x229.dynamic.ulsk.ertelecom.ru.59285: UDP, length 20
12:09:20.263550 IP host-209.51415 > broadband-5-228-163-97.ip.moscow.rt.ru.39489: UDP, length 58
12:09:20.277118 IP broadband-5-228-163-97.ip.moscow.rt.ru.39489 > host-209.51415: UDP, length 70
12:09:20.277283 IP host-209.51415 > 95-24-123-188.broadband.corbina.ru.21315: UDP, length 58
12:09:20.298847 IP 95-24-123-188.broadband.corbina.ru.21315 > host-209.51415: UDP, length 70
12:09:20.320971 IP host-209.44445 > 5x165x87x250.dynamic.bryansk.ertelecom.ru.51415: Flags [S], seq 407102465, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:20.320992 IP host-209.34933 > 167-95-50-69.clients.gthost.com.1035: Flags [S], seq 2777718063, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:20.320999 IP host-209.40071 > 193.160.204.57.1262: Flags [S], seq 2878830686, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.550517 IP host-209.58738 > _gateway.domain: 43047+ PTR? 140.108.240.5.in-addr.arpa. (44)
12:09:23.605023 IP host-209.51415 > 66.99.248.110.1024: UDP, length 20
12:09:23.605063 IP host-209.51415 > 178.76.224.48.51415: UDP, length 20
12:09:23.605279 IP host-209.41021 > 212.13.7.152.51415: Flags [S], seq 1527426721, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.605454 IP host-209.47157 > 23-95-32-170-host.colocrossing.com.43288: Flags [S], seq 3658078517, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.605507 IP host-209.51415 > 86-122-30-138.rdsnet.ro.46915: UDP, length 20
12:09:23.605594 IP host-209.53299 > 45.87.251.12.51415: Flags [S], seq 3046816371, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.605750 IP host-209.44867 > bbb7299f.virtua.com.br.51415: Flags [S], seq 2467441810, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.606003 IP host-209.51415 > 222.232.7.29.51415: UDP, length 20
12:09:23.606026 IP host-209.51415 > awakeaquamarine.ptr.network.60740: UDP, length 20
12:09:23.606102 IP host-209.55233 > 159.224.81.137.53210: Flags [S], seq 3625783104, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:23.617885 IP awakeaquamarine.ptr.network > host-209: ICMP awakeaquamarine.ptr.network udp port 60740 unreachable, length 56
12:09:23.631946 IP host-209.51634 > lr-in-f113.1e100.net.https: Flags [P.], seq 981521975:981522288, ack 3737772339, win 502, length 313
12:09:23.638381 IP host-209.54262 > mc.yandex.ru.https: Flags [P.], seq 1020747407:1020747451, ack 349555186, win 501, length 44
12:09:23.646817 IP mc.yandex.ru.https > host-209.54262: Flags [.], ack 44, win 177, length 0
12:09:23.648112 IP host-209.51622 > lr-in-f113.1e100.net.https: Flags [.], seq 2720846493:2720847905, ack 2560054169, win 502, length 1412
12:09:23.735278 IP host-209.56161 > _gateway.domain: 34393+ PTR? 133.204.212.155.in-addr.arpa. (46)
12:09:23.793672 IP 23-95-32-170-host.colocrossing.com.43288 > host-209.47157: Flags [R.], seq 0, ack 3658078518, win 0, length 0
12:09:23.863963 IP host-209.51634 > lr-in-f113.1e100.net.https: Flags [P.], seq 0:313, ack 1, win 502, length 313
12:09:25.105345 IP host-209.53287 > _gateway.domain: 54270+ PTR? 57.251.18.5.in-addr.arpa. (42)
12:09:25.120035 IP host-209.35165 > static-68-235-36-35.cust.tzulo.com.41424: Flags [S], seq 2831517287, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.179332 IP host-209.51415 > hoje-69-162-248-185.radiantenews.com.br.1035: UDP, length 20
12:09:25.179460 IP host-209.51415 > fp5a959a0c.oski401.ap.nuro.jp.51415: UDP, length 20
12:09:25.179558 IP host-209.51415 > cgn-pool-mni-46-53-245-178.telecom.by.40564: UDP, length 20
12:09:25.183708 IP host-209.51415 > ec2-35-157-76-109.eu-central-1.compute.amazonaws.com.19717: UDP, length 20
12:09:25.183737 IP host-209.51415 > 178.65.210.68.51415: UDP, length 20
12:09:25.183843 IP host-209.50555 > i202-238-35-141.us.mics.ne.jp.51415: Flags [S], seq 3473111766, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.183924 IP host-209.41937 > 146.70.174.92.44221: Flags [S], seq 2614377129, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.183937 IP host-209.51379 > maxfibra-177-93-68-227.yune.com.br.51415: Flags [S], seq 2177997015, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.183944 IP host-209.44657 > 112.91.94.69.51415: Flags [S], seq 288262974, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.183952 IP host-209.56067 > 185.237.186.54.1024: Flags [S], seq 1252461246, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.184063 IP host-209.51415 > 124.124.153.45.in-addr.arpa.27671: UDP, length 20
12:09:25.184121 IP host-209.39893 > 188.163.72.129.19859: Flags [S], seq 3273595950, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.184278 IP host-209.51415 > 95-26-184-91.broadband.corbina.ru.51413: UDP, length 20
12:09:25.184299 IP host-209.51415 > 210.178.66.27.51415: UDP, length 20
12:09:25.184311 IP host-209.51415 > 146.70.65.138.55324: UDP, length 20
12:09:25.184323 IP host-209.51415 > 176.88.31.169.51415: UDP, length 20
12:09:25.184334 IP host-209.51415 > 185-132-179-66.hosted-by-worldstream.net.51415: UDP, length 20
12:09:25.184386 IP host-209.35651 > 80-79-5-76.hosted-by-worldstream.net.51415: Flags [S], seq 2059497894, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.184453 IP host-209.51415 > 45.134.191.44.63795: UDP, length 20
12:09:25.184468 IP host-209.51415 > 109.201.56.231.51415: UDP, length 20
12:09:25.184518 IP host-209.36861 > 188.17.184.13.1070: Flags [S], seq 1478547592, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:25.184562 IP host-209.51415 > 5.187.69.199.1024: UDP, length 20
12:09:34.701599 IP host-209.38651 > _gateway.domain: 19934+ PTR? 229.59.167.5.in-addr.arpa. (43)
12:09:34.911987 IP host-209.45853 > l5-130-249-9.novotelecom.ru.51415: Flags [S], seq 1155616155, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:34.917117 IP _gateway.domain > host-209.38651: 19934 1/2/2 PTR 5x167x59x229.dynamic.ulsk.ertelecom.ru. (163)
12:09:34.918317 IP host-209.40858 > _gateway.domain: 59263+ PTR? 110.248.99.66.in-addr.arpa. (44)
12:09:44.784515 IP host-209.41811 > _gateway.domain: 62443+ PTR? 97.163.228.5.in-addr.arpa. (43)
12:09:46.079439 IP host-209.57292 > _gateway.domain: 44239+ PTR? 48.224.76.178.in-addr.arpa. (44)
12:09:46.111933 IP host-209.50737 > 220.179.31.2.51415: Flags [S], seq 1929769100, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:46.111966 IP host-209.45673 > 222.104.38.78.51415: Flags [S], seq 3120665508, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:46.170415 IP host-209.51415 > 178.158.221.198.1035: UDP, length 20
12:09:46.170462 IP host-209.51415 > 213.24.132.193.51413: UDP, length 20
12:09:46.170488 IP host-209.51415 > 188.163.74.38.41256: UDP, length 20
12:09:46.170563 IP host-209.51415 > h-158-174-57-240.A251.priv.bahnhof.se.51415: UDP, length 20
12:09:46.175995 IP host-209.60933 > 104.28.161.43.26512: Flags [S], seq 665760638, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:46.176020 IP host-209.49767 > badcc585.virtua.com.br.19328: Flags [S], seq 2630773460, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:09:46.176028 IP host-209.43731 > 221.229.52.175.51415: Flags [S], seq 1128976547, win 7300, options [mss 1460,nop,nop,sackOK,nop,wscale 0], length 0
12:10:01.464408 IP host-209.51089 > _gateway.domain: 32024+ PTR? 69.162.248.185.in-addr.arpa. (45)
^C12:10:01.484150 IP hosted-by.leaseweb.com.51415 > host-209.59523: Flags [R.], seq 0, ack 956930256, win 0, length 0

174 packets captured
11735 packets received by filter
11516 packets dropped by kernel
EOF
        echo ""

        digital_rain 5

        echo -e "${YELLOW}... $iteration ... ${NC}"
        echo -e "${GREEN}...goto...${NC}\n\n"
        iteration=$((iteration + 1))
        sleep 2
    done
}

# Проверка, что скрипт запущен в терминале
if [ -t 1 ]; then
    banner	
    echo -e "${CYAN}DevOps/Reverse Engineering Tasks${NC}"
    echo -e "${YELLOW}Для выхода нажмите Ctrl+C${NC}\n"
    sleep 2
    main_loop
else
    echo "Этот скрипт должен запускаться в терминале."
    exit 1
fi
