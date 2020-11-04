output "eip" {
  value = aws_eip.sbe-ubuntu2004-test.public_ip
  description = "Elastic IP assigned to instance"
}