#----compute/main.tf#----
data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "template_file" "user-init" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    firewall_subnets = element(var.subnet_ips, 1)
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = data.aws_ami.server_ami.id
  instance_type   = var.instance_type
  security_groups = [var.instance_sg]
  key_name        = var.key_name
  user_data       = data.template_file.user-init.rendered

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "tf_vpc" {
  id = var.tf_vpc_id
}

data "aws_subnet_ids" "tf_vpc" {
  vpc_id = data.aws_vpc.tf_vpc.id
}

resource "aws_autoscaling_group" "tf_asg" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnet_ids.tf_vpc.ids
  termination_policies = ["OldestLaunchConfiguration"]
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"

  min_size = 2
  max_size = 10

  tags = [
    {
      key                 = "Name"
      value               = "Web-Server"
      propagate_at_launch = true
    },
    {
      key                 = "GROUP_NAME"
      value               = var.group_name
      propagate_at_launch = true
    },
    {
      key                 = "DESCRIPTION"
      value               = "Web-Server"
      propagate_at_launch = true
    },
    {
      key                 = "BUSINESS_UNIT"
      value               = var.business_unit
      propagate_at_launch = true
    },
    {
      key                 = "APPLICATION"
      value               = var.application_name
      propagate_at_launch = true
    },
    {
      key                 = "COST_CENTER"
      value               = var.cost_center
      propagate_at_launch = true
    },
    {
      key                 = "CREATION_TIMESTAMP"
      value               = formatdate("DD-MMM-YYYY hh:mm ZZZ", timestamp())
      propagate_at_launch = true
    },
  ]
}

resource "aws_lb" "example" {

  name = var.alb_name

  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.tf_vpc.ids
  security_groups    = [var.alb_sg]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {

  name = var.alb_name

  port     = 80
  protocol = "HTTP"
  vpc_id   = var.tf_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

/* resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
} */


