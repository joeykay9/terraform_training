variable "ingressrules" {
  type = list(number)
  default = [ 80, 443 ]
}

variable "egressrules" {
  type = list(number)
  default = [ 80, 443 ]
}

resource "aws_security_group" "sg" {
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

output "name" {
  value = aws_security_group.sg.name
}