variable iam_role {
    type = string
    description = "The role's name"
}

variable assume_role_policy { 
    type = string
    description = "Policy that grants an entity permission to assume the role."
}

variable iam_role_policy {
    type = list(string)
    description = "The ARN list of the policy you want to apply"
}