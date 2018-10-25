#! /bin/sh

#######################
# REGLAS INTRANET/DMZ #
#######################

# Permitir equipos DMZ actualizarse y actualizar hora del sistema
iptables -A FORWARD -o $rojo -i $naranja -p tcp -m multiport --dport 53,80,443 -j ACCEPT
iptables -A FORWARD -o $rojo -i $naranja -p udp -m multiport --dport 53,123 -j ACCEPT

# Conexion a DMZ desde anfitrion, desde WLAN entre las 00:00 y 15:00, desde LAN siempre
iptables -A FORWARD -o $naranja -i $verde -d $serverweb -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -A FORWARD -o $naranja -i $azul -d $serverweb -p tcp -m multiport --dport 80,443 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT
iptables -A FORWARD -m mac --mac-source $mi_mac -i $verde -d $serverweb -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -t nat -A PREROUTING -i $rojo -p tcp -m multiport --dport 80,443 -j DNAT --to-destination $serverweb

# Desde WAN acceder por SHH a servidorweb (2222), openldap (22222), openldap no seguro (389), openldap seguro (636)
iptables -A FORWARD -m mac --mac-source $mi_mac -i $rojo -d $serverweb -p tcp --dport 22 -j ACCEPT
iptables -t nat -A PREROUTING -i $rojo -p tcp --dport 2222 -j DNAT --to-destination $serverweb:22
iptables -A FORWARD -m mac --mac-source $mi_mac -i $rojo -d $openldap -p tcp -m multiport --dport 22,389,636 -j ACCEPT
iptables -t nat -A PREROUTING -i $rojo -p tcp --dport 22222 -j DNAT --to-destination $openldap:22

# Desde LAN permitir acceso remoto a equipo en DMZ desde el anfitrion por MAC
iptables -A FORWARD -i $verde -d $windowsdmz -p tcp --dport 3389 -m mac --mac-source $mi_mac -j ACCEPT
iptables -t nat -A PREROUTING -i $verde -p tcp --dport 3389 -j DNAT --to-destination $windowsdmz

