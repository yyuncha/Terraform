resource "aws_iam_instance_profile" "iam_role_gitlab_profile" {
  name = var.iam_profile_name
  role = aws_iam_role.iam_role_gitlab.name
  tags = merge({ Name = var.iam_profile_name }, var.tags)
}

resource "aws_iam_role" "iam_role_gitlab" {
  name               = var.iam_name
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags               = merge({ Name = var.iam_name }, var.tags)
}
resource "aws_iam_role_policy_attachment" "gitlab_ssm_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.iam_role_gitlab.name
}

resource "aws_iam_role_policy_attachment" "gitlab_s3_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.iam_role_gitlab.name
}
resource "aws_iam_role_policy_attachment" "gitlab_ecr_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.iam_role_gitlab.name
}

resource "aws_iam_role_policy_attachment" "gitlab_ecs_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.iam_role_gitlab.name
}

resource "aws_iam_role_policy" "gitlab_iam_role_policy" {
  name   = var.iam_policy_name
  role   = aws_iam_role.iam_role_gitlab.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:RevokeGrant",
              "kms:ReEncryptTo",
              "kms:GenerateDataKey",
              "kms:GenerateDataKeyWithoutPlaintext",
              "kms:CreateGrant",
              "kms:ReEncryptFrom",
              "kms:ListGrants"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "KMStoEncryptFile"
      },
      {
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "AllowPull"
      },
      {
          "Action": [
              "s3:ListBucket",
              "s3:GetObject",
              "s3:GetBucketLocation",
              "s3:ListAllMyBuckets"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "GetObjectFromS3"
      },
      {
          "Action": [
              "cloudwatch:PutMetricData",
              "cloudwatch:Describe*",
              "cloudwatch:Get*",
              "cloudwatch:List*"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "CloudWatchPermission"
      },
      {
          "Action": [
              "ec2:AssociateIamInstanceProfile",
              "ec2:DescribeImages",
              "ec2:DeregisterImage",
              "ec2:CreateImage",
              "ec2:DescribeTags",
              "ec2:CreateTags",
              "ec2:DescribeInstances",
              "ec2:CreateSnapshot",
              "ec2:DeleteSnapshot",
              "ec2:DescribeSnapshotAttribute",
              "ec2:DescribeSnapshots",
              "ec2:ModifySnapshotAttribute",
              "ec2:ResetSnapshotAttribute",
              "ec2:DescribeReservedInstances",
              "ec2:ReplaceIamInstanceProfileAssociation",
              "ec2:DescribeRegions",
              "ec2:Describe*",
              "ec2:RunInstances",
              "ec2:RebootInstances",
              "ec2:StopInstances",
              "ec2:StartInstances",
              "ec2:TerminateInstances",
              "autoscaling:Describe*"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "EC2Permission"
      },
      {
          "Action": [
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams",
              "logs:GetLogEvents"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "GetLogsPermission"
      },
      {
          "Action": [
              "sns:Get*",
              "sns:List*"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "GetSNSPermission"
      },
      {
          "Action": [
              "sqs:GetQueueAttributes",
              "sqs:ListQueues",
              "sqs:ReceiveMessage",
              "sqs:GetQueueUrl",
              "sqs:SendMessage",
              "sqs:DeleteMessage"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "SQSPermission"
      },
      {
          "Action": [
              "cloudformation:DescribeStacks",
              "cloudformation:DescribeStackEvents",
              "cloudformation:DescribeStackResource"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "ClodformationDescribePermission"
      },
      {
          "Action": [
              "iam:GetUser",
              "iam:PassRole",
              "config:DeliverConfigSnapshot"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Sid": "IAMPermission"
      }
  ]
}
  EOF
}

resource "aws_iam_role_policy" "gitlab_assume_role_policy" {
  name   = var.iam_assume_policy_name
  role   = aws_iam_role.iam_role_gitlab.id
  policy = <<EOF
{
"Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": [
                "arn:aws:iam::613592045985:role/MasterAccountAccessRole"
            ]
        }
    ]
}
  EOF
}
