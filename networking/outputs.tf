#-----networking/outputs.tf----

output "tf_vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "public_subnets" {
  value = aws_subnet.tf_public_subnet.*.id
}

output "instance_sg" {
  value = aws_security_group.instance_sg.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "subnet_ips" {
  value = aws_subnet.tf_public_subnet.*.cidr_block
}

