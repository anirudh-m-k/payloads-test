#!/bin/bash
# Ubuntu Complete Enumeration → system_info.txt

cd ~/hack
echo "🛡️ Ubuntu Enumeration - $(date)" > system_info.txt
echo "================================================" >> system_info.txt

cat >> system_info.txt << 'EOF'

=== SYSTEM ===
$(lsb_release -a 2>/dev/null || cat /etc/os-release)
$(uname -a)
$(uptime)
$(cat /proc/version)

=== USERS & PERMS ===
$(whoami)
$(id)
$(groups)
$(w)
$(sudo -l 2>/dev/null || echo "No sudo")

=== NETWORK ===
$(ip a)
$(ip route)
$(ss -tuln)
$(hostname -I)
$(cat /etc/hosts)
$(curl -s ifconfig.me 2>/dev/null || echo "No public IP")

=== PROCESSES ===
$(ps aux | head -25)

=== SERVICES ===
$(systemctl list-units --type=service --state=running | head -20)

=== DISKS ===
$(lsblk -f)
$(df -h)
$(free -h)

=== HISTORY ===
$(history 2>/dev/null | tail -15 || echo "No history")
$(tail -20 ~/.bash_history 2>/dev/null || echo "No bash history")

=== CRON ===
$(crontab -l 2>/dev/null || echo "No user cron")
$(ls -la /etc/cron* 2>/dev/null)

=== WIFI ===
$(nmcli dev wifi list 2>/dev/null || echo "No wifi")
$(sudo grep psk= /etc/NetworkManager/system-connections/* 2>/dev/null || echo "No wifi pass")

=== SENSITIVE ===
$(find ~ -name "*.key" -o -name id_rsa* 2>/dev/null | head -5)
$(find /etc -name "*.conf" -exec grep -lE "(pass|key|secret)" {} + 2>/dev/null | head -5)

EOF

echo "✅ Complete - $(wc -l system_info.txt) lines" >> system_info.txt
