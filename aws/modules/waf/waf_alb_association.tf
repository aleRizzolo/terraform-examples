resource "aws_wafv2_web_acl_association" "waf_alb_association" {
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}