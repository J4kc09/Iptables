#! /bin/sh

####################
# REGLAS DE OUTPUT #
####################

# Ping desde firewall a todas las subredes
iptables -A OUTPUT -p icmp -j ACCEPT

# Actualizar firewall y enviar correos electronicos
iptables -A OUTPUT -p tcp -m multiport --dport 25,53,80,443 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Actualizar hora solo mediante rediris entre las 00:00 y las 15:00
iptables -A OUTPUT -d $rediris -p udp --dport 123 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT

# Perimitir acceso desde Firewall a equipos en WAN por SSH
iptables -A OUTPUT -o $rojo -p tcp --dport 22 -j ACCEPT

# Permitir acceso a equipos en LAN, WLAN y DMZ por SHH usando IPs
iptables -A OUTPUT -d $ips -p tcp --dport 22 -j ACCEPT

