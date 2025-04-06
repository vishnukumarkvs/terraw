
# Output the key name and path
output "key_name" {
  value = module.key_pair.key_pair_name
}

output "private_key_path" {
  value = local_file.private_key.filename
}

output "instance_public_ip" {
  value = aws_eip.instance_eip.public_ip
}
