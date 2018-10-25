#! /bin/sh

###################
# REGLAS DE INPUT #
###################

# Ping al firewall desde todas las subredes menos WAN
iptables -A INPUT -p icmp -i $verde -j ACCEPT
iptables -A INPUT -p icmp -i $azul -j ACCEPT
iptables -A INPUT -p icmp -i $naranja -j ACCEPT

# Acceder al firewall via SSH desde LAN y DMZ, WLAN no y si es WAN una sola conexion
iptables -A INPUT -i $verde -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i $naranja -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i $rojo -p tcp --syn --dport 22 -m connlimit ! --connlimit-above 1 -j ACCEPT

# Log de entradas SSH
iptables -A INPUT -i $rojo -p tcp --dport 22 -j LOG --log-prefix "IntentosSSHcarrascocarmona"

#VPN
iptables -A INPUT -p udp --dport 1194 -i $rojo -j ACCEPT
