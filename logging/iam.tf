resource "aws_iam_role" "iam_role_cloudtrail" {
  name = var.iam_role_cloudtrail_name

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}
resource "aws_iam_role" "iam_role_lambda" {
  name               = var.iam_role_lambda_name
  assume_role_policy = <<EOF
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
}
resource "aws_iam_role" "iam_role_flowlogs" {
  #count = var.flow_logs_enabled
  name = var.iam_role_flowlogs_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy_cloudtrail" {
  name       = var.iam_role_policy_cloudtrail_name
  role       = aws_iam_role.iam_role_cloudtrail.id
  policy     = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${var.shared_account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group_cloudtrail.name}:log-stream:${var.shared_account_id}_CloudTrail_${var.aws_region}*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${var.shared_account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group_cloudtrail.name}:log-stream:${var.shared_account_id}_CloudTrail_${var.aws_region}*"
            ]
        }
    ]
}
POLICY
  depends_on = [aws_iam_role.iam_role_cloudtrail]
}
resource "aws_iam_role_policy" "iam_role_policy_lambda" {
  name = var.iam_role_policy_lambda_name
  role = aws_iam_role.iam_role_lambda.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowAssumeRole",
        "Effect": "Allow",
        "Action": [
            "sts:AssumeRole"
        ],
        "Resource": [
            "*"
        ]
    },
  {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:ListBucket",
              "s3:PutObject"
            ],
            "Resource": "*"
        },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
  ]
}
POLICY
}
resource "aws_iam_role_policy" "iam_role_policy_flowlogs" {
  #count = var.flow_logs_enabled
  name = var.iam_role_policy_flowlogs_name
  role = aws_iam_role.iam_role_flowlogs.id


  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
  depends_on = [aws_iam_role.iam_role_flowlogs]
}
