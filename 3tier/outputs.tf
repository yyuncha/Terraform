output web_load_balancer {
    value = module.web_load_balancer.load_balancer
}

output web_target_group {
    value = module.web_load_balancer.target_group
}

output web_lb_security_group {
    value = module.web_load_balancer.lb_security_group
}

output web_security_group {
    value = module.web_auto_scaling.ap_security_group
}

output was_load_balancer {
    value = module.was_load_balancer.load_balancer
}

output was_target_group {
    value = module.was_load_balancer.target_group
}

output was_lb_security_group {
    value = module.was_load_balancer.lb_security_group
}

output was_security_group {
    value = module.was_auto_scaling.ap_security_group
}

output rds_mariadb {
    value = module.rds_mariadb.rds_mariadb
}