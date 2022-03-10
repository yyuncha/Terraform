# Create IAM Policy
resource "aws_iam_policy" "iam_policy" {
    name        = var.iam_policy.name
    description = var.iam_policy.description

    policy = var.iam_policy_json
}