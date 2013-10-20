#!/bin/bash

iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# First, set up reachability to server.
iptables -A INPUT -p tcp --dport 22 -i eth0 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -F
#iptables -t nat -A POSTROUTING -s 192.168.42.0/24 -o eth0 -j MASQUERADE # NAT setup
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # NAT setup
sysctl net.ipv4.ip_forward=1
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
ifconfig wlan0 192.168.42.1

#NTP allowed
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp --sport 123 -j ACCEPT

#DHCP allowed
iptables -A OUTPUT -p udp --sport 67:68 -j ACCEPT
iptables -A INPUT -p udp --dport 67:68 -j ACCEPT

# Now we start with the needed IPs.
iptables -F FORWARD
iptables -A FORWARD -i eth0 -o wlan0 -m conntrack --ctstate=RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -j ACCEPT
iptables -I OUTPUT -j ACCEPT -d 192.195.204.216 #conntest.nintendowifi.net
#iptables -I INPUT -j ACCEPT -d 192.195.204.216 #conntest.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 111.168.21.83 #nppl.c.app.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 65.112.85.91 #a248.e.akamai.net
iptables -I OUTPUT -j ACCEPT -d 54.218.98.74 #service.spr.app.nintendo.net
iptables -I OUTPUT -j ACCEPT -d 23.4.21.79 #npdl.cdn.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.139 #nasc.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 96.7.133.79 #cp3s.cdn.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.167 #cp3s-auth.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.164 #nus.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.162 #ecs.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.160 #cas.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.169 #pls.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 69.25.139.161 #ccs.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 96.17.148.121 #ccs.cdn.c.shop.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 173.226.198.200 #dsdl.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 202.32.117.172 #npul.c.app.nintendowifi.net
iptables -I OUTPUT -j ACCEPT -d 202.32.117.182 #hpp-00051600-l1.n.app.nintendowifi.net (swapnote)
iptables -I OUTPUT -j ACCEPT -d 176.32.99.43 #ctr-jfrj-live.s3.amazonaws.com (swapnote)
iptables -I OUTPUT -j ACCEPT -d 202.232.239.25 #friends support (UDP traffic ports 500xx)
iptables -I OUTPUT -j ACCEPT -d 203.180.85.69/32 #friends support (UDP traffic ports 500xx)
iptables -I OUTPUT -j ACCEPT -d 203.180.85.69/32 #friends support (UDP traffic ports 500xx)
#iptables -I OUTPUT -j ACCEPT -d 203.180.85.70/31 #friends support (UDP traffic ports 500xx)
iptables -I OUTPUT -j ACCEPT -d 203.180.85.70/31 #friends support (UDP traffic ports 500xx)
#iptables -I OUTPUT -j ACCEPT -d 203.180.85.72/29 #friends support (UDP traffic ports 500xx)
iptables -I OUTPUT -j ACCEPT -d 203.180.85.72/29 #friends support (UDP traffic ports 500xx)
#iptables -I OUTPUT -j ACCEPT -d 2.19.133.79
iptables -I OUTPUT -j ACCEPT -d 205.166.76.141 #searcher.wii.com
