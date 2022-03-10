output ap_security_group {
    value = var.security_group_ids != null ? aws_security_group.ap_security_group[0].id : var.security_group_ids[0]
}