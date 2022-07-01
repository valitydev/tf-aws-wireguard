locals {
  secrets            = jsondecode(data.aws_secretsmanager_secret_version.wg_secrets.secret_string)
  aws_region         = "eu-central-1"
  instance_type      = "t2.micro"
  wireguard_vpc_cidr = "10.8.0.0/22"
  wg_test_cidr       = "10.8.0.0/24"
  wg_server_cidr     = "10.8.1.0/24"
  wg_client_cidr     = "10.8.2.0/24"
  wg_server_pub_key  = "eaPwqq1fC+rEUZtCjm1frO+h1OfsP9qrGKNFVL9dhBI="
  wg_clients = [
    {
      friendly_name = "machine-1"
      public_key    = "jdljUSLhK+hno2OJxn6yrrY3rCu2Cx1E0xcyAT0NZ1M="
      client_ip     = "10.8.2.2/32"
    }
    , {
      friendly_name = "machine-2"
      public_key    = "teUCimfXpj4n/8NMwW2KjhKPz14Jg5Jpc731mdbCnUo="
      client_ip     = "10.8.2.3/32"
    }
  ]
  aws_tags = {
    service = "wireguard"
    team    = "security"
  }
}
