module "wireguard" {
  source                = "../"
  aws_region            = local.aws_region
  aws_tags              = local.aws_tags
  ssh_key_name          = aws_key_pair.alexey_p.key_name
  instance_type         = local.instance_type
  vpc_id                = aws_vpc.wireguard.id
  wg_server_subnet_id   = aws_subnet.wireguard_server.id
  wg_server_private_key = local.secrets.server_private_key
  wg_server_pub_key     = local.wg_server_pub_key
  wg_client_cidr        = local.wg_client_cidr
  wg_clients            = local.wg_clients
  instance_profile      = ""
}

data "aws_secretsmanager_secret_version" "wg_secrets" {
  secret_id = "wireguard-secrets"
}

resource "aws_key_pair" "alexey_p" {
  key_name   = "alexey-p-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDI3ntXp7HteQPh8wEi4ICJ0X0DWCmNP1VWA0r/gfdr/"
  tags       = local.aws_tags
}

resource "aws_vpc" "wireguard" {
  cidr_block           = local.wireguard_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.aws_tags
}

resource "aws_subnet" "wireguard_server" {
  vpc_id                  = aws_vpc.wireguard.id
  cidr_block              = local.wg_server_cidr
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.wireguard]
  tags                    = local.aws_tags
}

resource "aws_subnet" "wireguard_clients" {
  vpc_id     = aws_vpc.wireguard.id
  cidr_block = local.wg_client_cidr
  tags       = local.aws_tags
}

resource "aws_subnet" "wireguard_test_machines" {
  vpc_id     = aws_vpc.wireguard.id
  cidr_block = local.wg_test_cidr
  tags       = local.aws_tags
}

resource "aws_internet_gateway" "wireguard" {
  vpc_id = aws_vpc.wireguard.id
  tags   = local.aws_tags
}

resource "aws_route" "wg_srv_to_internet" {
  route_table_id         = aws_route_table.wireguard_srv.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wireguard.id
}

resource "aws_route_table" "wireguard_srv" {
  vpc_id = aws_vpc.wireguard.id
  tags   = local.aws_tags
}

resource "aws_route_table_association" "wireguard_srv" {
  subnet_id      = aws_subnet.wireguard_server.id
  route_table_id = aws_route_table.wireguard_srv.id
}

resource "aws_instance" "test" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.instance_type
  key_name               = aws_key_pair.alexey_p.key_name
  subnet_id              = aws_subnet.wireguard_test_machines.id
  hibernation            = false
  vpc_security_group_ids = [aws_security_group.wg_test.id]
  tags                   = local.aws_tags
  credit_specification {
    cpu_credits = "standard"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_security_group" "wg_test" {
  name        = "wireguard-test"
  description = "group for test instance"
  vpc_id      = aws_vpc.wireguard.id
  tags        = local.aws_tags

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.8.0.0/22"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
