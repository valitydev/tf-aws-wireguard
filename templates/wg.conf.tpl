[Interface]
Address = ${wg_server_net}
PrivateKey = ${wg_server_private_key}
ListenPort = ${wg_server_port}
PostUp = sysctl -w -q net.ipv4.ip_forward=1
PostUp = sysctl -w -q net.ipv6.conf.all.forwarding=1
PostUp = iptables -P FORWARD DROP
PostUp = ip6tables -P FORWARD DROP
PostUp = iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostUp = iptables -A FORWARD -i wg0 -m state --state NEW -j ACCEPT
PostDown = sysctl -w -q net.ipv4.ip_forward=0
PostDown = sysctl -w -q net.ipv6.conf.all.forwarding=0
PostDown = iptables -P FORWARD ACCEPT
PostDown = ip6tables -P FORWARD ACCEPT
PostDown = iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -m state --state NEW -j ACCEPT

%{ for client in clients ~}
[Peer]
# friendly_name = ${client.friendly_name}
PublicKey = ${client.public_key}
AllowedIPs = ${client.client_ip}
PersistentKeepalive = ${persistent_keepalive}
%{ endfor ~}
