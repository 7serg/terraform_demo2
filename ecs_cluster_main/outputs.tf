
output "s3_bucket_id" {
  value = aws_s3_bucket.demoecs_bucket.id
}

output "s3_bucket_region" {
  value = aws_s3_bucket.demoecs_bucket.region
}

output "vpc_id" {
  value = aws_vpc.demoecs_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.demoecs_vpc.cidr_block
}


output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}


output "public_route_table_id" {
  value = aws_route_table.public_subnets.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}


output "eip_for_nat" {
  value = aws_eip.elastic_ip_for_nat[*].id
}

output "aws_nat_gateway_ids" {
  value = aws_nat_gateway.for_private_subnets[*].id
}



output "private_route_table_id" {
  value = aws_route_table.private[*].id
}

output "security_group_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}

output "sg_webserver_id" {
  value = aws_security_group.webserver.id
}

output "web_server_ids" {
  value = aws_instance.web_server[*].id
}


output "aws_lb_id" {
  value = aws_lb.webserver.id
}

output "aws_lb_target_group_id" {
  value = aws_lb_target_group.webserver.id
}
