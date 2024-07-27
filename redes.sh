#!/bin/bash
# Para utilizar el comado de arp--scan se tiene que descargar la libreria, asi que, usamos el comando "sudo apt-get install arp-scan"

# Función para tener la dirección MAC de una IP específica
obtener_mac_address() {
    ip=$1
    mac=$(arp-scan --localnet | grep $ip | awk '{print $2}')
    echo "IP: $ip   MAC: $mac"
}

# Función para escanear puertos abiertos de una IP especifica
scaneo_ports() {
    ip=$1
    echo "Escaneando puertos abiertos en $ip..."
    nmap -p- --open -T4 $ip | grep ^[0-9] | awk '{print "Port:", $1, "State:", $2}'

}

# Escanea la red local y mostrar las direcciones IP y MAC de la compu
echo "Escaneando red local"
arp-scan --localnet | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | while read ip; do
    if [ "$ip" != "$(hostname -I)" ]; then
        obtener_mac_address $ip
        scaneo_ports $ip
    fi
done
