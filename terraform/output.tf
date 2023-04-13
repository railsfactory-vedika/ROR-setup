output "public_ip_ror" {
  value = aws_instance.ec2_instance.public_ip
}

output "public_ip_db" {
  value = aws_instance.postgres_db.public_ip
}