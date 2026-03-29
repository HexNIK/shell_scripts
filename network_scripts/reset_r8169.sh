#!/bin/bash

#вместо enp3s0 подставте ваш интерфейс c драйвеом r8169
echo "Восстановление enp3s0..."
sudo rmmod r8169 2>/dev/null
sudo modprobe r8169
sleep 2
sudo ifdown enp3s0 2>/dev/null
sudo ifup enp3s0
echo "Готово. Проверяем:"
ip addr show enp3s0 | grep inet

