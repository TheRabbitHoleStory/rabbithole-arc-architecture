output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "app_subnet_ids" {
  description = "App (private/isolated) subnet IDs"
  value       = [for s in aws_subnet.app : s.id]
}
