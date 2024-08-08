resource "aws_eip" "main" {
  instance = var.instance_id
}

output "eip" {
  value = aws_eip.main.public_ip
}
