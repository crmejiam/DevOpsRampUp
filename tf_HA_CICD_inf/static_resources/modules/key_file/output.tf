output "private_key_pem_content" {
    description = "content of the key.pem file"
    value = "${tls_private_key.private-key-generator.private_key_pem}"
}