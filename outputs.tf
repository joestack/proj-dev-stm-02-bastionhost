output "bastionhost_public_ip" {
  value = aws_instance.bastionhost.public_ip
}

output "bastionhost_private_ip" {
  value = aws_instance.bastionhost.private_ip
}

output "bastionhost_ssh_string" {
  value = "ssh ${var.ssh_user}@${aws_instance.bastionhost.public_ip}"
}

output "bastionhost_fqdn" {
  value = aws_route53_record.bastionhost.name
}
