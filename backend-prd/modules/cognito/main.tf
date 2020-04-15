
####################
# Cognito
####################
resource "aws_cognito_user_pool" "user_pool" {
  name = "beats_user_pool"
  alias_attributes = ["email"]
  username_configuration {
    case_sensitive           = false
  }

  verification_message_template{
    default_email_option     = "CONFIRM_WITH_CODE"
  }

  auto_verified_attributes = ["email"]

}

resource "aws_cognito_user_pool" "admin_pool" {
  name = "beats_admin_pool"
  username_configuration {
    case_sensitive = false
  }
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "app_user" {
  name = "mobile_app_user"
  generate_secret = false

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "app_admin" {
  name = "mobile_app_admin"
  generate_secret = false

  user_pool_id = aws_cognito_user_pool.admin_pool.id
}