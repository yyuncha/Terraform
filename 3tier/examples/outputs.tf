output web_load_balancer {
    value = module.Three_tier.web_load_balancer
}

output was_load_balancer {
    value = module.Three_tier.was_load_balancer
}

output rds_mariadb {
    value = module.Three_tier.rds_mariadb
}

