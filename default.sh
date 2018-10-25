#! /bin/sh

###########
# DEFAULT #
###########

echo "1" > /proc/sys/net/ipv4/ip_forward

# Reglas generales
iptables -F #Borra reglas exixtentes
iptables -X #Borra tablas existentes
iptables -Z #Reinicia contadores
iptables -t nat -F #Borra reglas existentes nat
iptables -t nat -X #Borra tablas nat existentes
iptables -t nat -Z #Reinicia contadores nat

# Politicas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Cortafuegos
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -t nat -A POSTROUTING -o wan152 -p icmp -j MASQUERADE
iptables -t nat -A POSTROUTING -o wan152 -p tcp -j MASQUERADE
iptables -t nat -A POSTROUTING -o wan152 -p udp -j MASQUERADE

# Respuestas
iptables -t filter -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -t filter -A FORWARD -m state --state ESTABLISHED -j ACCEPT

