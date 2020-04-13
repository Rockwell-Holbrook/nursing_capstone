# Adds AWS as the provider and sets a profile and region
provider "aws" {
  alias = "singapore"
  profile = "nursing"
  region  = var.region_ap
}


####################
# API Gateway
####################
module "api-ap" {

  source                   = "./modules/api"
  name                     = "Beats-var.stage_name-API-AP"
  stage_name               = var.stage_name
  accountId                = var.account_id
  region                   = var.region_ap
  ###### Cognito Pools ######
  user_pool               = module.cognito.user_pool
  admin_pool               = module.cognito.admin_pool
  ###### Lambda Names and Invoke Arns ######
  #### Patients #### 
  ## Get all patients ##
  get_all_pats             = module.lambda-ap.get_all_pats
  get_all_pats_arn         = module.lambda-ap.get_all_pats_arn
  ## Get patient ##
  get_pat                  = module.lambda-ap.get_pat
  get_pat_arn              = module.lambda-ap.get_pat_arn
  ## Update patient ##
  upd_pat                  = module.lambda-ap.upd_pat
  upd_pat_arn              = module.lambda-ap.upd_pat_arn
  ## Delete patient ##
  del_pat                  = module.lambda-ap.del_pat
  del_pat_arn              = module.lambda-ap.del_pat_arn
  ## New patient ##
  new_pat                  = module.lambda-ap.new_pat
  new_pat_arn              = module.lambda-ap.new_pat_arn 

  #### Recordings ####
  ## Get all recordings for patient ##
  get_all_recs             = module.lambda-ap.get_all_recs
  get_all_recs_arn         = module.lambda-ap.get_all_recs_arn
  ## Get recording ##
  get_rec                  = module.lambda-ap.get_rec
  get_rec_arn              = module.lambda-ap.get_rec_arn
  ## Delete recording ##
  del_rec                  = module.lambda-ap.del_rec
  del_rec_arn              = module.lambda-ap.del_rec_arn
  ## New recording ##
  new_rec                  = module.lambda-ap.new_rec
  new_rec_arn              = module.lambda-ap.new_rec_arn 

  providers = {
    aws = aws.singapore
  }
}

####################
# Dynamo
####################
module "dynamo-ap" {
  source                   = "./modules/dynamo"
  name                     = "Beats-Database"
  providers = {
    aws = aws.singapore
  }
}
####################
# Lambda
####################
module "lambda-ap" {
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
  write_all_arn              = module.iam.write_all_arn
  ## Do All ##
  do_all_arn                = module.iam.do_all_arn
  ###### Names ######
  ## DBs ##
  recs_db_name              = module.dynamo-ap.recs_db_name
  pats_db_name              = module.dynamo-ap.pats_db_name
  ## S3 ##
  s3_name                   = module.s3-ap.recs_s3_name_ap
  
  providers = {
    aws = aws.singapore
  }
}

####################
# S3
####################
module "s3-ap" {
  source = "./modules/s3-ap"
  name = "byu-beats-recordings-${var.stage_name}"

  providers = {
    aws = aws.singapore
  }
}