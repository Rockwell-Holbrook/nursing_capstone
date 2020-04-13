####################
# IAM
####################
module "iam" {
  source                   = "./modules/iam"
  name                     = "Beats-Backend-IAM"
  ###### Dynamo Tables ######
  ## Patients ##
  pats_db_us_arn              = module.dynamo-us.pats_db
  pats_db_ap_arn              = module.dynamo-ap.pats_db
  ## Recordings ##
  recs_db_us_arn              = module.dynamo-us.recs_db
  recs_db_ap_arn              = module.dynamo-ap.recs_db
  ###### S3 Buckets ######
  recs_s3_us_arn              = module.s3.recs_s3_us
  recs_s3_ap_arn              = module.s3-ap.recs_s3_ap
}

module "replication"{
  source                   = "./modules/replication"
  name                     = "Beats-Database"
}