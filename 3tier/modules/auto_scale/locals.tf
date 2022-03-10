locals {
    launch_configuration = var.auto_scale_lc_name == null ? null : aws_launch_configuration.autoscale_lc[0].name
    launch_template = var.auto_scale_lt_name == null ? null : var.use_mixed_instances_policy == false ? aws_launch_template.autoscale_lt[0].name : null

    security_group_ids = var.ap_security_group != null && var.security_group_ids != null ? concat(var.security_group_ids, [ for security_group in aws_security_group.ap_security_group: security_group.id ]) : (var.ap_security_group == null ? var.security_group_ids : [ for security_group in aws_security_group.ap_security_group: security_group.id ])
}