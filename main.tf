resource "aws_instance" "wireguard" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = var.wg_server_subnet_id
  source_dest_check      = false
  hibernation            = false
  vpc_security_group_ids = [aws_security_group.wireguard.id]
  user_data              = local.user_data
  iam_instance_profile   = var.instance_profile
  credit_specification {
    cpu_credits = "standard"
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = var.aws_tags
}

resource "aws_eip" "wireguard" {
  vpc      = true
  instance = aws_instance.wireguard.id
  tags     = var.aws_tags
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
