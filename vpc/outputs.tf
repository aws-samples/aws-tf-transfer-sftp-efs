output "vpc_id" {
  description = "VPC Id for the provisioned VPC"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnet_ids" {
  description = "Subnet Id(s) for the provisioned public Subnets"
  value       = module.vpc.public_subnets
}

output "vpc_private_subnet_ids" {
  description = "Subnet Id(s) for the provisioned public Subnets"
  value       = module.vpc.private_subnets
}

output "r53_hosted_zones" {
  description = "Route 53 hosted zones created"
  value       = [for pvt_zone in aws_route53_zone.pvt_zone : pvt_zone.name]
}
