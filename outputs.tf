output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "application_private_ip" {
  description = "Private IP address of the application host"
  value       = aws_instance.application.private_ip
}
