locals {
  # First ip in subnet, 10.8.0.0/24 -> 10.8.0.1/24
  wg_server_net = replace(var.wg_client_cidr, "/.*\\//", "${cidrhost(var.wg_client_cidr, 1)}/")
  wg_conf = templatefile("${path.module}/templates/wg.conf.tpl", {
    clients               = var.wg_clients
    wg_server_net         = local.wg_server_net
    wg_server_private_key = var.wg_server_private_key
    wg_server_port        = var.wg_server_port
    persistent_keepalive  = var.wg_persistent_keepalive
  })
  user_data = templatefile("${path.module}/templates/user-data.txt", {
    wg_server_port = var.wg_server_port,
    wg_conf        = local.wg_conf,
  })

}
