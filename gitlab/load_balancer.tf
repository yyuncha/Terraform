resource "aws_lb" "gitlab_lb" {
  name               = var.lb_name
  internal           = false # internal =true(내부트래픽), =false(외부인터넷트래픽)
  subnets            = var.subnet_ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.gitlab_sg_external.id]

  tags = merge({ Name = var.lb_name }, var.tags)
}

resource "aws_lb_listener" "gitlab_lb_listener_80" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "gitlab_lb_listener_443" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = aws_acm_certificate.gitlab_acm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_lb_target_group.arn
  }
  #depends_on = [aws_acm_certificate_validation.gitlab_acm_cert_valid]
}

resource "aws_lb_target_group" "gitlab_lb_target_group" {
  name     = var.lb_target_group_name
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 10
    interval            = 120
    matcher             = "200,301,302"
    path                = "/-/helath"
    timeout             = 60
  }

  tags = merge({ Name = var.lb_target_group_name }, var.tags)
  lifecycle {
    create_before_destroy = true #만일 ALB가 재생성되어야 한다면 새로운 ALB를 먼저 생성후 예전 ALB를 지우도록 함.
  }
}

resource "aws_lb_target_group_attachment" "gitlab_lb_target_group-attchment" {
  target_group_arn = aws_lb_target_group.gitlab_lb_target_group.arn
  target_id        = aws_instance.gitlab_ec2_instance.id
  port             = 80
}
