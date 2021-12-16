resource "tls_private_key" "private-key-generator" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.key_pair_name       # Create a key pair to AWS
  public_key = tls_private_key.private-key-generator.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = pathexpand("C:/Users/cristian.mejiam/Desktop/cmm-rampup-key-ansible.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.private-key-generator.private_key_pem
}