#!/bin/bash
# ============================================================
# WireGuard Add Client Script
# Run as root on the server after setup-wireguard-server.sh
# Usage: ./add-wireguard-client.sh <client-name> <client-ip-last-octet>
# Example: ./add-wireguard-client.sh laptop 2
# ============================================================
set -e

CLIENT_NAME="${1:-client1}"
LAST_OCTET="${2:-2}"
CLIENT_VPN_IP="10.0.0.${LAST_OCTET}"
WG_DIR="/etc/wireguard"
SERVER_PUBLIC=$(cat "$WG_DIR/server_public.key")
SERVER_IP=$(curl -s https://api.ipify.org)

echo "==> Generating keys for $CLIENT_NAME..."
cd "$WG_DIR"
umask 077
wg genkey | tee "${CLIENT_NAME}_private.key" | wg pubkey > "${CLIENT_NAME}_public.key"

CLIENT_PRIVATE=$(cat "${CLIENT_NAME}_private.key")
CLIENT_PUBLIC=$(cat "${CLIENT_NAME}_public.key")

echo "==> Adding peer to wg0.conf..."
cat >> "$WG_DIR/wg0.conf" << PEER

[Peer]
# ${CLIENT_NAME}
PublicKey = ${CLIENT_PUBLIC}
AllowedIPs = ${CLIENT_VPN_IP}/32
PEER

echo "==> Writing client config file..."
cat > "$WG_DIR/${CLIENT_NAME}.conf" << CLIENTCONF
[Interface]
PrivateKey = ${CLIENT_PRIVATE}
Address = ${CLIENT_VPN_IP}/32
DNS = 1.1.1.1

[Peer]
PublicKey = ${SERVER_PUBLIC}
Endpoint = ${SERVER_IP}:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
CLIENTCONF

echo "==> Reloading WireGuard to apply new peer..."
wg syncconf wg0 <(wg-quick strip wg0)

echo ""
echo "======================================================"
echo " Client config: $WG_DIR/${CLIENT_NAME}.conf"
echo " VPN IP assigned: $CLIENT_VPN_IP"
echo "======================================================"
echo ""
echo "==> Generating QR code (scan with WireGuard mobile app):"
qrencode -t ansiutf8 < "$WG_DIR/${CLIENT_NAME}.conf"
