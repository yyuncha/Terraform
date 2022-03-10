output load_balancer {
    value = aws_lb.load_balancer.arn
}

output target_group {
    value = aws_lb_target_group.target_group.arn
}

output lb_security_group {
    value = var.load_balancer_type == "application" ? aws_security_group.lb_security_group[0].id : null
}