#!/bin/bash
# ============================================================
# VPN Verification Script
# Run on client after connecting to confirm VPN is working
# ============================================================

echo "=== Public IP Check ==="
echo "Your public IP (should be your VPN server's IP):"
curl -s https://api.ipify.org && echo ""
echo ""

echo "=== DNS Leak Test ==="
echo "DNS servers in use:"
if command -v dig &>/dev/null; then
    dig +short TXT whoami.ds.akahelp.net | head -5
else
    nslookup myip.opendns.com resolver1.opendns.com 2>/dev/null | grep Address | tail -1
fi
echo "(Should show 1.1.1.1 or your VPN server — not your ISP's DNS)"
echo ""

echo "=== WireGuard Peer Status (run on server) ==="
echo "  sudo wg show"
echo ""

echo "=== Ping Test ==="
echo "Pinging VPN gateway (10.0.0.1 for WireGuard / 10.8.0.1 for OpenVPN):"
ping -c 3 10.0.0.1 2>/dev/null || ping -c 3 10.8.0.1 2>/dev/null || echo "  (Not connected to VPN)"
