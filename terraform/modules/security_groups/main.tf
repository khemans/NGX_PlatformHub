resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb"
  description = "Ingress to application load balancer."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-sg-alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ipv4" {
  for_each = toset(var.alb_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  description         = "HTTP from allowed CIDRs"

  cidr_ipv4   = each.value
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}-ecs-tasks"
  description = "ECS Fargate task ENIs."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-sg-ecs-tasks"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_tasks.id
  description                  = "App traffic from ALB"
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_tasks_egress_ipv4" {
  security_group_id = aws_security_group.ecs_tasks.id
  description         = "Egress to VPC and internet via NAT"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_ipv4" {
  security_group_id = aws_security_group.alb.id
  description       = "To ECS tasks"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "aurora" {
  name        = "${var.name_prefix}-aurora"
  description = "Aurora cluster access."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-sg-aurora"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "aurora_from_ecs" {
  security_group_id            = aws_security_group.aurora.id
  description                  = "PostgreSQL from ECS tasks"
  referenced_security_group_id = aws_security_group.ecs_tasks.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "aurora_egress_ipv4" {
  security_group_id = aws_security_group.aurora.id
  description         = "No outbound required for typical RDS; allow DNS if needed"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
