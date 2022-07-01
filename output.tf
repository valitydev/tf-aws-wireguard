output "client_configs" {
  value = templatefile("${path.module}/templates/wg-client.conf.tpl", {
    clients              = var.wg_clients
    wg_server_port       = var.wg_server_port,
    persistent_keepalive = var.wg_persistent_keepalive,
    wg_server_pub_key    = var.wg_server_pub_key,
    allowed_ips          = join(",", tolist(data.aws_vpc.all.*.cidr_block)),
    server_ip            = aws_eip.wireguard.public_ip
  })
}

data "aws_vpc" "all" {
  count = length(data.aws_vpcs.all.ids)
  id    = tolist(data.aws_vpcs.all.ids)[count.index]
}

data "aws_vpcs" "all" {
}
