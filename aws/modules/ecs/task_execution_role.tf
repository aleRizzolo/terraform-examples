# connects to ecr
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_execution_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "stmt1745856839212",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.app_name}-execution-role"
  }
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "ecr_pull_policy"
  description = "Policy to allow ECS to pull images from private ECR and public registry"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PrivateECRRepositoryAccess",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages",
          "ecr:ListTagsForResource"
        ],
        "Resource" : "arn:aws:ecr:*:*:repository/*"
      },
      {
        "Sid" : "GetAuthorizationToken",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
      {
        "Sid" : "PublicECRRepositoryAccess",
        "Effect" : "Allow",
        "Action" : [
          "ecr-public:DescribeImages",
          "ecr-public:GetAuthorizationToken",
          "ecr-public:BatchGetImage",
          "ecr-public:GetDownloadUrlForLayer",
          "ecr-public:ListImages"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PublicECRServiceAccess",
        "Effect" : "Allow",
        "Action" : "sts:GetServiceBearerToken",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pull_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}