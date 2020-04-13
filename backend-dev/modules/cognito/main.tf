
####################
# Cognito
####################
resource "aws_cognito_user_pool" "user_pool" {
  name = "beats_user_pool"
  
}

resource "aws_cognito_user_pool_client" "app" {
  name = "mobile_app"
  generate_secret = true

  user_pool_id = aws_cognito_user_pool.user_pool.id
}
