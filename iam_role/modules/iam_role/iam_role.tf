# Create IAM Role
resource "aws_iam_role" "iam_role" {
    name = var.iam_role
    assume_role_policy = var.assume_role_policy
}

# Attaches a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
    count = length(var.iam_role_policy)
    role = aws_iam_role.iam_role.name
    policy_arn = var.iam_role_policy[count.index]
}