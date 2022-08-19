resource "aws_instance" "db" {
  ami = "ami-089950bc622d39ed8"
  instance_type = "t2.micro"

  tags = {
    "Name" = "DB Server"
  }
}

output "instance_id" {
  value = aws_instance.db.id
}

output "private_ip" {
  value = aws_instance.db.private_ip
}