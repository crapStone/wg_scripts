#!/bin/bash
# wg_clientconf.sh

# Generating a new pair of keys for the client and create the config-file for a new client

# Generating a new pair of keys:
wg genkey | tee "$1"_private_key | wg pubkey > "$1"_public_key

# Create the next IP-Adress:
NO=$(sudo tail -n 1 /etc/wireguard/wg0.conf)
echo ${NO##*.} > tmp
NOO=$(cat tmp)
echo ${NOO%/*} > tmp1
echo $[1 + $(cat tmp1)] > tmp2
NOOO=$(cat tmp2)
IPADDR="10.10.10.${NOOO}/32"
echo "$IPADDR" > tmp3

#echo "Enter the name of the client: "
#read CNAME

PRIVKEY=$(cat "$1"_private_key)

# Create the .conf for the client:
echo "[Interface]
	PrivateKey = ${PRIVKEY}
	Address = $(cat tmp3)
	DNS = 192.168.178.27

      [Peer]
      PublicKey = $(sudo cat /etc/wireguard/keys/serverkeys/server_public_key)
  	Endpoint = dominicb.ddns.net:51820
	AllowedIPs = 0.0.0.0/0, 192.168.178.0/24
	PersistentKeepalive = 25" > "$1".conf


# Create the QR-Code:
echo "This is your qr-code: "
echo ""
echo ""
qrencode -t ansiutf8 < "$1".conf
