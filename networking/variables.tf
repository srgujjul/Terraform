#----networking/variables.tf----
variable "vpc_cidr" {
}

variable "public_cidrs" {
  type = list(string)
}

variable "accessip" {
}

variable "instance_security_group_name" {
  description = "The name of the security group for the EC2 Instances"
  type        = string
  default     = "terraform-instance-sg"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "terraform-alb-sg"
}

