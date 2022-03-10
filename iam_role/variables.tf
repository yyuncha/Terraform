variable iam_policy { 
    type = map
    description = "The policy's name and description"
}

variable iam_policy_json { 
    type = string
    description = "The policy document. This is a JSON formatted string."
}

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