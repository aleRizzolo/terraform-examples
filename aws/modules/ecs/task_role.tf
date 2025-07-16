# ECS Task Role - Solo per ElastiCache
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
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

# Policy per ElastiCache
resource "aws_iam_policy" "cache_policy" {
  name        = "cache_policy"
  description = "Policy to allow ECS to interact with ElastiCache"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticache:Connect"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach ElastiCache policy
resource "aws_iam_role_policy_attachment" "ecs_cache_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.cache_policy.arn
}