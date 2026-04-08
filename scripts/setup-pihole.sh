#!/bin/bash
# ============================================================
# Pi-hole Setup for VPN Ad Blocking
# Run on your VPN server after WireGuard/OpenVPN is running
# ============================================================
set -e

echo "==> Installing Pi-hole (unattended)..."
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended

echo ""
echo "==> Pi-hole installed!"
echo ""
echo "==> Updating VPN DNS to point to Pi-hole..."
echo ""
echo "For WireGuard — edit /etc/wireguard/wg0.conf:"
echo "  (no change needed server-side; update each client config:)"
echo "  DNS = 10.0.0.1"
echo ""
echo "For OpenVPN — edit /etc/openvpn/server.conf, change:"
echo "  push \"dhcp-option DNS 10.8.0.1\""
echo "  (remove the 1.1.1.1 and 8.8.8.8 lines)"
echo ""
echo "Then restart your VPN service:"
echo "  systemctl restart wg-quick@wg0"
echo "  # or"
echo "  systemctl restart openvpn@server"
echo ""
echo "Pi-hole admin panel: http://$(curl -s https://api.ipify.org)/admin"
