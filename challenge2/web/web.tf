resource "aws_instance" "web" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"
  security_groups = [ module.sg.name ]
  user_data = file("server-script.sh")

  tags = {
    "Name" = "Web Server"
  }
}

module "eip" {
  source = "../eip"
  instance_id = aws_instance.web.id
}

module "sg" {
  source = "../sg"
}

output "public_ip" {
  value = module.eip.public_ip
}