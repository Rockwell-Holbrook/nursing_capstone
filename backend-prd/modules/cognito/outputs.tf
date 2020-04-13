output "user_pool" {
  value = "${aws_cognito_user_pool.user_pool.arn}"
}

output "admin_pool" {
  value = "${aws_cognito_user_pool.admin_pool.arn}"
}