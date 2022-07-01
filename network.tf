resource "aws_route" "to_wireguard_middlebox" {
  count                  = var.create_routes ? length(data.aws_route_tables.rts.ids) : 0
  route_table_id         = tolist(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block = var.wg_client_cidr
  instance_id            = aws_instance.wireguard.id
  lifecycle {
    ignore_changes = [network_interface_id]
  }
}

data "aws_route_tables" "rts" {
  vpc_id = var.vpc_id
}
