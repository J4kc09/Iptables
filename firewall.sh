#! /bin/sh

############
# FIREWALL #
############

echo "Activando Firewall"

## REGLAS GENERALES ##
. /root/iptables/default.sh
echo "Reglas generales aplicadas"

## VARIABLES ##
. /root/iptables/variables.sh
echo "Variables definidas"

## REGLAS INPUT ##
. /root/iptables/input.sh
echo "Reglas de INPUT aplicadas"

## REGLAS OUTPUT ##
. /root/iptables/output.sh
echo "Reglas de OUTPUT aplicadas"

## REGLAS DMZ-WAN ##
. /root/iptables/intranet-wan.sh
echo "Reglas para DMZ con el exterior aplicadas"

## REGLAS DMZ ##
. /root/iptables/intranet-dmz.sh
echo "Reglas para intranet DMZ aplicadas"

echo "Firewall activado"
