// Name of project
variable "name" {
  description = "Name of lambdas"
}

//Memory size of all lambdas
variable "memory_size" {
  default = "128"
}

## IAM ##
variable "read_pats_db_arn" {
  description = "IAM Role"
}

variable "write_pats_db_arn" {
  description = "IAM Role"
}

variable "read_recs_db_s3_arn" {
  description = "IAM Role"
}

variable "read_all_arn" {
  description = "IAM Role"
}

variable "write_all_arn" {
  description = "IAM Role"
}

variable "do_all_arn" {
  description = "IAM Role"
}

variable "pats_db_name" {
  description = "Dynamo DB Table Name"
}

variable "recs_db_name" {
  description = "Dynamo DB Table Name"
}

variable "s3_name" {
  description = "Dynamo DB Table Name"
}