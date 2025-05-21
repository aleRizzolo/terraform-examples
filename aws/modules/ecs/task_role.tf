# connects to documentdb
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
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
    Name = "${var.app_name}-task-role"
  }
}

resource "aws_iam_policy" "docb_policy" {
  name        = "docdb_policy"
  description = "Policy to allow ECS to interact with documentdb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # For DocumentDB elastic cluster specifically
          "docdb-elastic:GetCluster",
          "docdb-elastic:ListClusters",
          "docdb-elastic:ListTagsForResource",
          "docdb-elastic:BatchGetItem",
          "docdb-elastic:GetItem",
          "docdb-elastic:Query",
          "docdb-elastic:Scan",
          "docdb-elastic:PutItem",
          "docdb-elastic:UpdateItem",
          "docdb-elastic:DeleteItem"
        ]
        Resource = "*"
      }
    ]
  })
}

# connect to cache
resource "aws_iam_policy" "cache_policy" {
  name        = "cache_policy"
  description = "Policy to allow ECS to interact with elasticache"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ElastiCacheConnectAccess",
        "Effect" : "Allow",
        "Action" : [
          "elasticache:Connect"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_docdb_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.docb_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_cache_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.cache_policy.arn
}