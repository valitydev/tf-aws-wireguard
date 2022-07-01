variable "aws_region" {
  type = string
}

variable "aws_tags" {
  description = "AWS tags"
  default     = {}
}

variable "ssh_key_name" {
  description = "A SSH public key ID to add to the VPN instance."
  default = ""
}

variable "instance_profile" {
  description = "IAM instance profile"
  default     = ""
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The machine type to launch."
}

variable "vpc_id" {
  description = "The VPC ID in which Terraform will launch the resources."
}

variable "wg_server_subnet_id" {
  description = "Subnet ID to deploy Wireguard."
}

variable "wg_client_cidr" {
  description = "WG client CIDR block"
  type        = string
}

variable "create_routes" {
  description = "Create required routes in all tables"
  default     = true
}

variable "wg_clients" {
  type        = list(object({ friendly_name = string, public_key = string, client_ip = string }))
  description = "List of client objects with IP and public key. See Usage in README for details."
}

variable "wg_server_port" {
  default     = 51820
  description = "Port for the vpn server."
}

variable "wg_persistent_keepalive" {
  default     = 25
  description = "Persistent keepalive."
}

variable "wg_server_private_key" {
  type        = string
  default     = null
  description = "WG server private key."
  sensitive   = true
}

variable "wg_server_pub_key" {
  description = "WG server public key for client configs."
  default     = ""
}
