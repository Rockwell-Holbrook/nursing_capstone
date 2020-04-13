# Adds AWS as the provider and sets a profile and region
provider "aws" {
  profile = "nursing"
  region  = var.region_us
}


####################
# API Gateway
####################
module "api-us" {

  source                   = "./modules/api"
  stage_name               = var.stage_name
  name                     = "Beats-${var.stage_name}-API"
  accountId                = var.account_id
  region                   = var.region_us
  ###### Cognito Poos ######
  user_pool               = module.cognito.user_pool
  ###### Lambda Names and Invoke Arns ######
  #### Patients #### 
  ## Get all patients ##
  get_all_pats             = module.lambda-us.get_all_pats
  get_all_pats_arn         = module.lambda-us.get_all_pats_arn
  ## Get patient ##
  get_pat                  = module.lambda-us.get_pat
  get_pat_arn              = module.lambda-us.get_pat_arn
  ## Update patient ##
  upd_pat                  = module.lambda-us.upd_pat
  upd_pat_arn              = module.lambda-us.upd_pat_arn
  ## Delete patient ##
  del_pat                  = module.lambda-us.del_pat
  del_pat_arn              = module.lambda-us.del_pat_arn
  ## New patient ##
  new_pat                  = module.lambda-us.new_pat
  new_pat_arn              = module.lambda-us.new_pat_arn 

  #### Recordings ####
  ## Get all recordings for patient ##
  get_all_recs             = module.lambda-us.get_all_recs
  get_all_recs_arn         = module.lambda-us.get_all_recs_arn
  ## Get recording ##
  get_rec                  = module.lambda-us.get_rec
  get_rec_arn              = module.lambda-us.get_rec_arn
  ## Delete recording ##
  del_rec                  = module.lambda-us.del_rec
  del_rec_arn              = module.lambda-us.del_rec_arn
  ## New recording ##
  new_rec                  = module.lambda-us.new_rec
  new_rec_arn              = module.lambda-us.new_rec_arn 
} 

####################
# Cognito
####################
module "cognito" {
  source                   = "./modules/cognito"
}
####################
# Dynamo
####################
module "dynamo-us" {
  source                   = "./modules/dynamo"
  name                     = "Beats-Database"
}
####################
# Lambda
####################
module "lambda-us" {
  source                   = "./modules/lambda"
  name                     = "Beats_Backend" 
  ###### IAM Roles ######
  ## Read Patient DB ##
  read_pats_db_arn          = module.iam.read_pats_db_arn
  ## Write Patient DB ##
  write_pats_db_arn         = module.iam.write_pats_db_arn
  ## Read Recordings DB / S3 ##
  read_recs_db_s3_arn       = module.iam.read_recs_db_s3_arn
  ## Read All ##
  read_all_arn              = module.iam.read_all_arn
  ## Write All ##
  write_all_arn             = module.iam.write_all_arn
  ## Do All ##
  do_all_arn                = module.iam.do_all_arn
  ###### Names ######
  ## DBs ##
  recs_db_name              = module.dynamo-us.recs_db_name
  pats_db_name              = module.dynamo-us.pats_db_name
  ## S3 ##
  s3_name                   = module.s3.recs_s3_name_us
}

####################
# S3
####################
module "s3" {
  source = "./modules/s3"
  name = "byu-beats-recordings"
  ###### IAM Role ######
  recs_s3_replication       = module.iam.recs_s3_replication
  ###### S3 in AP ######
  recs_db_s3_arn            = module.s3-ap.recs_s3_ap
}

resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = "api.byu-dept-nursingsteth-dev.amazon.byu.edu"
  regional_certificate_arn = "arn:aws:acm:us-west-2:179843822640:certificate/a3970cf2-34e9-46ad-97a0-c398e3d862c8"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}