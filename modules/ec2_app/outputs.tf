output "instance_ids" {
  value = aws_instance.app[*].id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}
