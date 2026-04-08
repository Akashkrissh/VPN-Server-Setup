#!/bin/bash
# ============================================================
# OpenVPN + Easy-RSA Server Setup Script
# Run as root on Ubuntu 20.04+
# ============================================================
set -e

CA_DIR="$HOME/openvpn-ca"
OVPN_DIR="/etc/openvpn"

echo "==> Detecting network interface..."
NET_IF=$(ip route | grep default | awk '{print $5}' | head -n1)
echo "    Using interface: $NET_IF"

echo "==> Installing OpenVPN and Easy-RSA..."
apt update -qq && apt install -y openvpn easy-rsa

echo "==> Setting up CA directory..."
make-cadir "$CA_DIR"
cd "$CA_DIR"

echo "==> Initializing PKI..."
./easyrsa init-pki

echo "==> Building CA (no password)..."
./easyrsa build-ca nopass

echo "==> Generating server key pair..."
./easyrsa gen-req server nopass

echo "==> Signing server certificate..."
./easyrsa sign-req server server

echo "==> Generating Diffie-Hellman parameters (this may take a few minutes)..."
./easyrsa gen-dh

echo "==> Generating TLS auth key..."
openvpn --genkey secret ta.key

echo "==> Copying files to $OVPN_DIR..."
mkdir -p /var/log/openvpn
cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem ta.key "$OVPN_DIR/"

echo "==> Writing server.conf..."
cp "$(dirname "$0")/server.conf" "$OVPN_DIR/server.conf"
# Patch the NAT interface
sed -i "s/eth0/$NET_IF/g" "$OVPN_DIR/server.conf" 2>/dev/null || true

echo "==> Enabling IP forwarding..."
grep -qxF 'net.ipv4.ip_forward=1' /etc/sysctl.conf || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

echo "==> Configuring NAT..."
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$NET_IF" -j MASQUERADE

echo "==> Opening firewall port 1194/udp..."
if command -v ufw &>/dev/null; then
    ufw allow 1194/udp
    ufw --force enable
fi

echo "==> Starting OpenVPN..."
systemctl enable --now openvpn@server
systemctl status openvpn@server --no-pager

echo ""
echo "======================================================"
echo " OpenVPN server is running!"
echo " Run add-openvpn-client.sh to generate client configs."
echo "======================================================"
