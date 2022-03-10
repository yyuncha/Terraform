module "iam_role" {
    source              = "../"
    
    iam_policy          = {
        name = "KMS_Permission"
        description = "KMS_Permission"
    }

    iam_policy_json     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey",
                "kms:ReEncrypt*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
    iam_role            = "Lambda_Role"
    assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
    iam_role_policy     = [
        "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    ]
}