%{ for client in clients ~}
# ${client.friendly_name}

[Interface]
PrivateKey = PUT_YOUR_PRIVATE_KEY_HERE
Address = ${client.client_ip}

[Peer]
PublicKey = ${wg_server_pub_key}
AllowedIPs = ${allowed_ips}
Endpoint = ${server_ip}:${wg_server_port}
PersistentKeepalive = ${persistent_keepalive}

%{ endfor ~}
