provider "aws" {
    region = "eu-west-1"
}

module "db" {
  source = "./db"
}

module "web" {
  source = "./web"
}

output "dbserver_privateip" {
    value = module.db.private_ip
}

output "public_ip" {
  value = module.web.public_ip
}