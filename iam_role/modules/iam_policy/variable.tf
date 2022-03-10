variable iam_policy { 
    type = map
    description = "The policy's name and description"
}

variable iam_policy_json { 
    type = string
    description = "The policy document. This is a JSON formatted string."
}