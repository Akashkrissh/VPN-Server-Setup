#!/bin/bash
# ============================================================
# WireGuard Server Setup Script
# Run as root on Ubuntu 20.04+
# ============================================================
set -e

WG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
WG_PORT="51820"
VPN_SUBNET="10.0.0.0/24"
SERVER_VPN_IP="10.0.0.1"

echo "==> Detecting network interface..."
NET_IF=$(ip route | grep default | awk '{print $5}' | head -n1)
echo "    Using interface: $NET_IF"

echo "==> Installing WireGuard..."
apt update -qq && apt install -y wireguard resolvconf qrencode

echo "==> Generating server keys..."
cd "$WG_DIR"
umask 077
wg genkey | tee server_private.key | wg pubkey > server_public.key

SERVER_PRIVATE=$(cat server_private.key)
SERVER_PUBLIC=$(cat server_public.key)
echo "    Server public key: $SERVER_PUBLIC"

echo "==> Enabling IP forwarding..."
grep -qxF 'net.ipv4.ip_forward=1' /etc/sysctl.conf || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
grep -qxF 'net.ipv6.conf.all.forwarding=1' /etc/sysctl.conf || echo 'net.ipv6.conf.all.forwarding=1' >> /etc/sysctl.conf
sysctl -p

echo "==> Writing wg0.conf..."
cat > "$WG_DIR/wg0.conf" << WGCONF
[Interface]
Address = ${SERVER_VPN_IP}/24
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIVATE}
PostUp   = iptables -A FORWARD -i ${WG_INTERFACE} -j ACCEPT; iptables -t nat -A POSTROUTING -o ${NET_IF} -j MASQUERADE
PostDown = iptables -D FORWARD -i ${WG_INTERFACE} -j ACCEPT; iptables -t nat -D POSTROUTING -o ${NET_IF} -j MASQUERADE
WGCONF

chmod 600 "$WG_DIR/wg0.conf"

echo "==> Opening firewall port $WG_PORT/udp..."
if command -v ufw &>/dev/null; then
    ufw allow "$WG_PORT/udp"
    ufw --force enable
else
    iptables -A INPUT -p udp --dport "$WG_PORT" -j ACCEPT
fi

echo "==> Starting WireGuard..."
systemctl enable --now "wg-quick@${WG_INTERFACE}"
systemctl status "wg-quick@${WG_INTERFACE}" --no-pager

echo ""
echo "======================================================"
echo " WireGuard server is running!"
echo " Server public key: $SERVER_PUBLIC"
echo " Run add-wireguard-client.sh to add your first client."
echo "======================================================"
