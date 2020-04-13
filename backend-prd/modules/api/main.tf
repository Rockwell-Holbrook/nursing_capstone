####################
# API Gateway
####################
resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Backend API for the BYU Nursing Stethoscope (aka. Beats)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Authorizers
resource "aws_api_gateway_authorizer" "all" {
  name          = "UserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  provider_arns = [var.user_pool, var.admin_pool]
}


################# Resources #################
######## /patients ########
resource "aws_api_gateway_resource" "pats_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "patients"
}

######## /patients/{pat_id} ########
resource "aws_api_gateway_resource" "pats_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.pats_resource.id
  path_part   = "{pat_id}"
}

######## /patients/{pat_id}/recordings ########
resource "aws_api_gateway_resource" "pats_recs_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.pats_id_resource.id
  path_part   = "recordings"
}

######## /patients/{pat_id}/recordings/{rec_id} ########
resource "aws_api_gateway_resource" "pats_recs_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.pats_recs_resource.id
  path_part   = "{rec_id}"
}




################# Methods #################
######## Get All Patients ########
resource "aws_api_gateway_method" "get_all_pats_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## New Patient Method ########
resource "aws_api_gateway_method" "new_pat_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Get Patient ########
resource "aws_api_gateway_method" "get_pat_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_id_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Update Patient ########
resource "aws_api_gateway_method" "upd_pat_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_id_resource.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Delete Patient ########
resource "aws_api_gateway_method" "del_pat_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_id_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Get All Recordings ########
resource "aws_api_gateway_method" "get_all_recs_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_recs_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## New Recording ########
resource "aws_api_gateway_method" "new_rec_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_recs_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Get Recording ########
resource "aws_api_gateway_method" "get_rec_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_recs_id_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}

######## Delete Recording ########
resource "aws_api_gateway_method" "del_rec_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pats_recs_id_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.all.id
}



################# Proxies #################
######## Get All Patients ########
resource "aws_api_gateway_integration" "get_all_pats" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.get_all_pats_method.resource_id
  http_method = aws_api_gateway_method.get_all_pats_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_pats_arn
}

######## New Patient Method ########
resource "aws_api_gateway_integration" "new_pat" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.new_pat_method.resource_id
  http_method = aws_api_gateway_method.new_pat_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.new_pat_arn
}

######## Get Patient ########
resource "aws_api_gateway_integration" "get_pat" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.get_pat_method.resource_id
  http_method = aws_api_gateway_method.get_pat_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_pat_arn
}

######## Update Patient ########
resource "aws_api_gateway_integration" "upd_pat" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.upd_pat_method.resource_id
  http_method = aws_api_gateway_method.upd_pat_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.upd_pat_arn
}

######## Delete Patient ########
resource "aws_api_gateway_integration" "del_pat" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.del_pat_method.resource_id
  http_method = aws_api_gateway_method.del_pat_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.del_pat_arn
}

######## Get All Patient Recordings Method ########
resource "aws_api_gateway_integration" "get_all_recs" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.get_all_recs_method.resource_id
  http_method = aws_api_gateway_method.get_all_recs_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_all_recs_arn
}

######## New Patient Recording Method ########
resource "aws_api_gateway_integration" "new_rec" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.new_rec_method.resource_id
  http_method = aws_api_gateway_method.new_rec_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.new_rec_arn
}

######## Get Recording ########
resource "aws_api_gateway_integration" "get_rec" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.get_rec_method.resource_id
  http_method = aws_api_gateway_method.get_rec_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_rec_arn
}

######## Delete Recording ########
resource "aws_api_gateway_integration" "del_rec" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.del_rec_method.resource_id
  http_method = aws_api_gateway_method.del_rec_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.del_rec_arn
}


################# Proxies #################
######## Get All Patients ########
resource "aws_lambda_permission" "get_all_pats" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_pats
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_all_pats_method.http_method}${aws_api_gateway_resource.pats_resource.path}"
}

######## New Patient Method ########
resource "aws_lambda_permission" "new_pat" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.new_pat
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.new_pat_method.http_method}${aws_api_gateway_resource.pats_resource.path}"
}

######## Get Patient ########
resource "aws_lambda_permission" "get_pat" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_pat
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_pat_method.http_method}${aws_api_gateway_resource.pats_id_resource.path}"
}

######## Update Patient ########
resource "aws_lambda_permission" "upd_pat" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.upd_pat
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.upd_pat_method.http_method}${aws_api_gateway_resource.pats_id_resource.path}"
}

######## Delete Patient ########
resource "aws_lambda_permission" "del_pat" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.del_pat
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.del_pat_method.http_method}${aws_api_gateway_resource.pats_id_resource.path}"
}

######## Get All Patient Recordings Method ########
resource "aws_lambda_permission" "get_all_recs" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_all_recs
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_all_recs_method.http_method}${aws_api_gateway_resource.pats_recs_resource.path}"
}

######## New Recording ########
resource "aws_lambda_permission" "new_rec" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.new_rec
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.new_rec_method.http_method}${aws_api_gateway_resource.pats_recs_resource.path}"
}

######## Get Recording ########
resource "aws_lambda_permission" "get_rec" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.get_rec
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.get_rec_method.http_method}${aws_api_gateway_resource.pats_recs_id_resource.path}"
}

######## Delete Recording ########
resource "aws_lambda_permission" "del_rec" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.del_rec
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.del_rec_method.http_method}${aws_api_gateway_resource.pats_recs_id_resource.path}"
}


################# Deployment #################
resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.get_all_pats,
    aws_api_gateway_integration.get_pat,
    aws_api_gateway_integration.upd_pat,
    aws_api_gateway_integration.new_pat,
    aws_api_gateway_integration.del_pat,
    aws_api_gateway_integration.get_all_recs,
    aws_api_gateway_integration.get_rec,
    aws_api_gateway_integration.new_rec,
    aws_api_gateway_integration.del_rec
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
}

