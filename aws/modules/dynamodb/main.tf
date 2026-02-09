resource "aws_dynamodb_table" "my-app_db" {
  name         = "${var.app_name}-dynamodb"
  billing_mode = var.billing_mode
}