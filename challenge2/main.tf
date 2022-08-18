provider "aws" {
    region = "eu-west-1"
}

variable "ingressrules" {
  type = list(number)
  default = [ 80, 443 ]
}

variable "egressrules" {
  type = list(number)
  default = [ 80, 443 ]
}

resource "aws_instance" "dbserver" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"

  tags = {
    "Name" = "DB Server"
  }
}

resource "aws_instance" "webserver" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.webserver_securitygroup.name ]
  user_data = file("server-script.sh")

  tags = {
    "Name" = "Web Server"
  }
}

resource "aws_security_group" "webserver_securitygroup" {
    name = "Alow Web Traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
        from_port = port.value
        protocol = "TCP"
        to_port = port.value
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
        from_port = port.value
        protocol = "TCP"
        to_port = port.value
        cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_eip" "webserverpublicip" {
  instance = aws_instance.webserver.id
}

output "dbserver_privateip" {
    value = aws_instance.dbserver.private_ip
}

output "webserver_publicip" {
  value = aws_eip.webserverpublicip.public_ip
}