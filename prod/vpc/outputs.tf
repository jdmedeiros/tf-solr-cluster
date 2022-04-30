output "aws_vpc_main_id" {
  description = "AWS vpc id. "
  value = aws_vpc.main.id
}

output "aws_subnet_default_id" {
  description = "AWS subnet top id. "
  value = aws_subnet.default.id
}

# Some sanity checking to make sure we are in the right account - very important if you use multiple accounts
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

