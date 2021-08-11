output "public_addresses" {
  value = {
      nginx_1 = aws_instance.nginx_1.public_ip
      nginx_2 = aws_instance.nginx_2.public_ip
  }  
}

output "private_addresses" {
  value = {
      nginx_1 = aws_instance.nginx_1.private_ip
      nginx_2 = aws_instance.nginx_2.private_ip
  }
}