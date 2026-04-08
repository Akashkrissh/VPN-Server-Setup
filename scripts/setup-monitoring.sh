#!/bin/bash
# ============================================================
# VPN Monitoring Setup
# Installs vnstat (bandwidth) and sets up a wg watch alias
# ============================================================
set -e

echo "==> Installing vnstat..."
apt install -y vnstat

echo "==> Enabling vnstat for wg0..."
vnstat -i wg0 --add 2>/dev/null || true
systemctl enable --now vnstat

echo ""
echo "==> Adding shell aliases to ~/.bashrc..."
cat >> ~/.bashrc << 'ALIASES'

# VPN monitoring aliases
alias vpn-status='wg show'
alias vpn-watch='watch -n 2 wg show'
alias vpn-bw='vnstat -i wg0'
alias vpn-bw-live='vnstat -i wg0 -l'
alias vpn-log='journalctl -u wg-quick@wg0 -f'
ALIASES

source ~/.bashrc 2>/dev/null || true

echo ""
echo "======================================================"
echo " Monitoring ready! Available commands:"
echo "   vpn-status   — show connected peers"
echo "   vpn-watch    — live refresh every 2 seconds"
echo "   vpn-bw       — bandwidth stats for wg0"
echo "   vpn-bw-live  — real-time bandwidth"
echo "   vpn-log      — follow WireGuard journal"
echo "======================================================"
