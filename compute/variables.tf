#----compute/variables.tf----
variable "key_name" {
}

variable "public_key_path" {
}

variable "subnet_ips" {
  type = "list"
}

variable "instance_type" {}

variable "instance_sg" {}

variable "alb_sg" {}

variable "tf_vpc_id" {}

variable "subnets" {
  type = "list"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
  default     = "terraform-asg-example"
}

variable "group_name" {
  description = "GROUP_NAME"
  type        = string
  default     = "GROUP 1"
}

variable "business_unit" {
  description = "BUSINESS_UNIT"
  type        = string
  default     = "BU 1"
}

variable "application_name" {
  description = "GROUP_NAME"
  type        = string
  default     = "APP_ONE"
}

variable "cost_center" {
  description = "COST_CENTER"
  type        = string
  default     = "COST_CENTER_1"
}
