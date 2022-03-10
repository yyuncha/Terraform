resource "aws_security_group" "gitlab_sg_external" {
  vpc_id      = var.vpc_id
  name        = var.security_group_external
  description = "Allow Access ALB"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.whitelist_ips
    description = "HTTPS access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.whitelist_ips
    description = "HTTP access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = var.security_group_external }, var.tags)
}

resource "aws_security_group" "gitlab_sg_internal" {
  vpc_id      = var.vpc_id
  name        = var.security_group_internal
  description = "Allow Access GitLab VM"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.gitlab_sg_external.id]
    description     = "HTTPS access"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = var.security_group_internal }, var.tags)
}
