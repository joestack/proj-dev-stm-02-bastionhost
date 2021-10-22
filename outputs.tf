output "Bastionhost_public_IP" {
  value = "ssh ${var.ssh_user}@${aws_instance.bastionhost.public_ip}"
}

output "Bastionhost_DNS" {
  value = aws_route53_record.bastionhost.name
}
