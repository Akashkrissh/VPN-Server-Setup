# VPN Server Setup Kit

![License](https://img.shields.io/badge/license-MIT-blue.svg)  
![Shell Script](https://img.shields.io/badge/language-Bash-green.svg)  
![Platform](https://img.shields.io/badge/platform-Linux%20%28Ubuntu%29-lightgrey.svg)  
![VPN](https://img.shields.io/badge/VPN-WireGuard%20%7C%20OpenVPN-blueviolet.svg)  
![Status](https://img.shields.io/badge/status-Production%20Ready-success.svg)

---

## Overview

The VPN Server Setup Kit is a production-ready automation toolkit designed to deploy and manage secure VPN infrastructure using WireGuard and OpenVPN.

It enables rapid provisioning of VPN servers with minimal configuration, making it suitable for secure remote access, private networking, and scalable backend infrastructure.

---

## Key Highlights (Recruiter Focus)

- Designed and implemented a secure VPN infrastructure using modern protocols (WireGuard, OpenVPN)
- Automated end-to-end server provisioning using Bash scripting
- Built scalable client management system with dynamic configuration generation
- Implemented network security practices including IP forwarding and firewall configuration
- Supported full-tunnel and split-tunnel routing for flexible network control
- Integrated optional monitoring and DNS-based ad-blocking capabilities
- Focused on performance, security, and ease of deployment

---

## Tech Stack

- Networking: WireGuard, OpenVPN  
- Scripting: Bash  
- Operating System: Ubuntu (20.04+)  
- Security: UFW, iptables, secure key exchange  
- Monitoring (optional): vnstat  
- DNS Filtering (optional): Pi-hole  

---

## Project Structure

```
vpn-setup/
├── wireguard/
│   ├── setup-wireguard-server.sh
│   ├── add-wireguard-client.sh
│   ├── wg0.conf
│   ├── client configs
│
├── openvpn/
│   ├── setup-openvpn-server.sh
│   ├── add-openvpn-client.sh
│   ├── server.conf
│
└── scripts/
    ├── verify-vpn.sh
    ├── setup-pihole.sh
    └── setup-monitoring.sh
```

---

## Quick Start

### WireGuard Setup

```
scp -r vpn-setup/ root@YOUR_SERVER_IP:~/
ssh root@YOUR_SERVER_IP

cd ~/vpn-setup/wireguard
chmod +x *.sh
sudo ./setup-wireguard-server.sh

sudo ./add-wireguard-client.sh laptop 2
```

---

### OpenVPN Setup

```
cd ~/vpn-setup/openvpn
chmod +x *.sh
sudo ./setup-openvpn-server.sh

sudo ./add-openvpn-client.sh laptop
```

---

## Verification

```
curl https://api.ipify.org
```

```
wg show
```

```
bash scripts/verify-vpn.sh
```

---

## Features

- Automated VPN deployment
- Secure client configuration generation
- Multi-device support
- Full and split tunneling
- Network monitoring integration
- DNS-based ad blocking (optional)
- Verification and debugging tools

---

## System Requirements

- Ubuntu 20.04 or later
- Root or sudo access
- Open ports:
  - 51820/UDP (WireGuard)
  - 1194/UDP (OpenVPN)

---

## Use Cases

- Secure remote access to systems
- Private network tunneling
- Protection on public Wi-Fi
- Bypassing network restrictions
- Backend infrastructure security

---

## Future Enhancements

- Docker-based deployment
- Web-based dashboard for management
- Multi-server orchestration
- Automated scaling

---

## Why This Project Stands Out

This project demonstrates strong practical knowledge of:

- Network security and VPN protocols  
- Backend automation using scripting  
- System design for scalable infrastructure  
- Real-world deployment and DevOps practices  

It reflects the ability to build production-level systems beyond theoretical concepts.

---

## Contributing

Contributions are welcome. Fork the repository and submit a pull request.

---
