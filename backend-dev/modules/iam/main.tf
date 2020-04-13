####################
# IAM
####################

############## LAMBDAS ##############
######## Role ########
## Read Patient DB ##
resource "aws_iam_role" "read_pats_db" {
  name = "${var.name}-read_pats_db"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Write Patient DB ##
resource "aws_iam_role" "write_pats_db" {
  name = "${var.name}-write_pats_db"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Read Recordings DB / S3 ##
resource "aws_iam_role" "read_recs_db_s3" {
  name = "${var.name}-read_recs_db_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Read All ##
resource "aws_iam_role" "read_all" {
  name = "${var.name}-read_all"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Write All ##
resource "aws_iam_role" "write_all" {
  name = "${var.name}-write_all"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Do All ##
resource "aws_iam_role" "do_all" {
  name = "${var.name}-do_all"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

######## Policy ########
## Read Patient ##
resource "aws_iam_policy" "read_pats_db" {
  name = "${var.name}-read_pats_db"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "dynamodb:BatchGetItem",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
      ],
      "Resource": [
          "${var.pats_db_us_arn}",
          "${var.pats_db_ap_arn}"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:GetParameters",
         "ssm:GetParameter",
        "ssm:GetParametersByPath"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
   }
  ]
}
EOF
}

## Write Patient ##
resource "aws_iam_policy" "write_pats_db" {
  name = "${var.name}-write_pats_db"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateItem"
      ],
      "Resource": [
          "${var.pats_db_us_arn}",
          "${var.pats_db_ap_arn}"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:GetParameters",
         "ssm:GetParameter",
        "ssm:GetParametersByPath"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
   }
  ]
}
EOF
}

## Read Recordings ##
resource "aws_iam_policy" "read_recs_db_s3" {
  name = "${var.name}-read_recs_db_s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "dynamodb:BatchGetItem",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
      ],
      "Resource": [
          "${var.recs_db_us_arn}",
          "${var.recs_db_ap_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
            "s3:GetObject",
            "s3:ListBucket"
      ],
      "Resource": [
          "${var.recs_s3_us_arn}",
          "${var.recs_s3_us_arn}/*",
          "${var.recs_s3_ap_arn}",
          "${var.recs_s3_ap_arn}/*"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:GetParameters",
         "ssm:GetParameter",
        "ssm:GetParametersByPath"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
   }
  ]
}
EOF
}

## Write Recordings ##
resource "aws_iam_policy" "write_recs_db_s3" {
  name = "${var.name}-write_recs_db_s3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateItem"
      ],
      "Resource": [
          "${var.recs_db_us_arn}",
          "${var.recs_db_ap_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject",
            "s3:ListBucket"
      ],
      "Resource": [
          "${var.recs_s3_us_arn}",
          "${var.recs_s3_us_arn}/*",
          "${var.recs_s3_ap_arn}",
          "${var.recs_s3_ap_arn}/*"
      ]
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
    },
    {
      "Action": [
        "ssm:GetParameters",
         "ssm:GetParameter",
        "ssm:GetParametersByPath"
      ],
      "Resource": ["*"],
      "Effect": "Allow"
   }
  ]
}
EOF
}

######## Attachment ########
## Read Pats DB ##
resource "aws_iam_role_policy_attachment" "read_pats_db" {
  role       = aws_iam_role.read_pats_db.name
  policy_arn = aws_iam_policy.read_pats_db.arn
}

## Write Pats DB ##
resource "aws_iam_role_policy_attachment" "write_pats_db" {
  role       = aws_iam_role.write_pats_db.name
  policy_arn = aws_iam_policy.write_pats_db.arn
}

## Read Recs ##
resource "aws_iam_role_policy_attachment" "read_recs_db_s3" {
  role       = aws_iam_role.read_recs_db_s3.name
  policy_arn = aws_iam_policy.read_recs_db_s3.arn
}

## Read All ##
resource "aws_iam_role_policy_attachment" "read_all_pats_db" {
  role       = aws_iam_role.read_all.name
  policy_arn = aws_iam_policy.read_pats_db.arn
}

resource "aws_iam_role_policy_attachment" "read_all_recs_db_s3" {
  role       = aws_iam_role.read_all.name
  policy_arn = aws_iam_policy.read_recs_db_s3.arn
}

## Write All ##
resource "aws_iam_role_policy_attachment" "write_all_pats_db" {
  role       = aws_iam_role.write_all.name
  policy_arn = aws_iam_policy.write_pats_db.arn
}

resource "aws_iam_role_policy_attachment" "write_all_recs_db_s3" {
  role       = aws_iam_role.write_all.name
  policy_arn = aws_iam_policy.write_recs_db_s3.arn
}

## Do All ##
resource "aws_iam_role_policy_attachment" "do_all_write_pats_db" {
  role       = aws_iam_role.do_all.name
  policy_arn = aws_iam_policy.write_pats_db.arn
}

resource "aws_iam_role_policy_attachment" "do_all_write_recs_db_s3" {
  role       = aws_iam_role.do_all.name
  policy_arn = aws_iam_policy.write_recs_db_s3.arn
}

resource "aws_iam_role_policy_attachment" "do_all_read_pats_db" {
  role       = aws_iam_role.do_all.name
  policy_arn = aws_iam_policy.read_pats_db.arn
}

resource "aws_iam_role_policy_attachment" "do_all_read_recs_db_s3" {
  role       = aws_iam_role.do_all.name
  policy_arn = aws_iam_policy.read_recs_db_s3.arn
}

############## S3 ##############
resource "aws_iam_role" "recs_s3_replication" {
  name = "${var.name}-recs_s3_replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "recs_s3_replication" {
  name = "${var.name}-recs_s3_replication"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.recs_s3_us_arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${var.recs_s3_us_arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${var.recs_s3_ap_arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "recs_s3_replication" {
  role       = aws_iam_role.recs_s3_replication.name
  policy_arn = aws_iam_policy.recs_s3_replication.arn
}