### main.tf ###

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    region = var.aws_region
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# INSTANCES

resource "aws_instance" "bastionhost" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.foundation.outputs.bastionhost_subnet_id
  private_ip                  = data.terraform_remote_state.foundation.outputs.bastionhost_priv_ip
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [data.terraform_remote_state.foundation.outputs.bastionhost_asg_id]
  key_name                    = var.pub_key

  user_data = <<-EOF
              #!/bin/bash
              echo "${local.priv_key}" >> /home/ubuntu/.ssh/id_rsa
              chown ubuntu /home/ubuntu/.ssh/id_rsa
              chgrp ubuntu /home/ubuntu/.ssh/id_rsa
              chmod 600 /home/ubuntu/.ssh/id_rsa
              apt-get update -y
              apt-get install ansible -y 
              EOF

  tags = {
    Name        = "bastionhost-${var.name}"
  }
}






resource "aws_route53_record" "bastionhost" {
  zone_id = data.terraform_remote_state.foundation.outputs.dns_zone_id
  name    = lookup(aws_instance.bastionhost.*.tags[0], "Name")
  #name    = "bastionhost"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.bastionhost.public_ip]
}


