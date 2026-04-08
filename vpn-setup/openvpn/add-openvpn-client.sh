#!/bin/bash
# ============================================================
# OpenVPN Add Client Script
# Usage: ./add-openvpn-client.sh <client-name>
# Example: ./add-openvpn-client.sh laptop
# ============================================================
set -e

CLIENT_NAME="${1:-client1}"
CA_DIR="$HOME/openvpn-ca"
OVPN_DIR="/etc/openvpn"
OUTPUT="$HOME/${CLIENT_NAME}.ovpn"
SERVER_IP=$(curl -s https://api.ipify.org)

echo "==> Generating key pair for $CLIENT_NAME..."
cd "$CA_DIR"
./easyrsa gen-req "$CLIENT_NAME" nopass
./easyrsa sign-req client "$CLIENT_NAME"

echo "==> Assembling .ovpn file..."
cat > "$OUTPUT" << OVPN
client
dev tun
proto udp
remote ${SERVER_IP} 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-GCM
auth SHA256
verb 3
key-direction 1
<ca>
$(cat "$CA_DIR/pki/ca.crt")
</ca>
<cert>
$(openssl x509 -in "$CA_DIR/pki/issued/${CLIENT_NAME}.crt")
</cert>
<key>
$(cat "$CA_DIR/pki/private/${CLIENT_NAME}.key")
</key>
<tls-auth>
$(cat "$OVPN_DIR/ta.key")
</tls-auth>
OVPN

chmod 600 "$OUTPUT"
echo ""
echo "======================================================"
echo " Done! Client config: $OUTPUT"
echo " Transfer to your device via SCP:"
echo "   scp root@${SERVER_IP}:${OUTPUT} ./"
echo "======================================================"
