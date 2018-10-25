#! /bin/sh

#############################
# REGLAS INTRANET/DMZ A WAN #
#############################

# Todas las subredes pueden hacer ping a la WAN
iptables -A FORWARD -o $rojo -p icmp -j ACCEPT

# Los servidores podran actualizar la hora con rediris en su IP y de 00:00 a 15:00
iptables -A FORWARD -o $rojo -s $openldap -d $rediris -p udp --dport 123 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT
iptables -A FORWARD -o $rojo -s $cabinadedisco -d $rediris -p udp --dport 123 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT
iptables -A FORWARD -o $rojo -s $serverweb -d $rediris -p udp --dport 123 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT
iptables -A FORWARD -o $rojo -s $serverweb2 -d $rediris -p udp --dport 123 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT

# Los equipos que existen en la LAN se podrán actualizar y consultar webs (dns, http y https)
for ip in $(seq 2 4);
    do
        iptables -A FORWARD -o $rojo -i $verde -s 192.168.100.$ip -p tcp -m multiport --dport 53,80,443 -j ACCEPT
        iptables -A FORWARD -o $rojo -i $verde -s 192.168.100.$ip -p udp --dport 53 -j ACCEPT
    done

# En la WLAN solo habrá conexion http/s entre las 00:00 y 15:00, en lAN y DMZ todo el dia
iptables -A FORWARD -o $rojo -i $azul -p tcp -m multiport --dport 80,443 -m time --timestart 00:00 --timestop 15:00 --kerneltz -j ACCEPT
iptables -A FORWARD -o $rojo -i $verde -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -A FORWARD -o $rojo -i $naranja -p tcp -m multiport --dport 80,443 -j ACCEPT

# Denegar acceso por http a Facebook, Tuenti, Twitter y Whatsapp
iptables -I FORWARD -p tcp --dport 443 -m string --string "facebook.com" --algo kmp -j DROP
iptables -I FORWARD -p tcp --dport 443 -m string --string "tuenti.es" --algo kmp -j DROP
iptables -I FORWARD -p tcp --dport 443 -m string --string "twitter.com" --algo kmp -j DROP
iptables -I FORWARD -p tcp --dport 443 -m string --string "whatsapp.com" --algo kmp -j DROP

