resource "aws_security_group" "wireguard" {
  name        = "wireguard-${var.aws_region}"
  description = "Wireguard server. In: 22/tcp, ${var.wg_server_port}/udp; Out: any."
  vpc_id      = var.vpc_id
  tags        = var.aws_tags

  ingress {
    from_port   = var.wg_server_port
    to_port     = var.wg_server_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
