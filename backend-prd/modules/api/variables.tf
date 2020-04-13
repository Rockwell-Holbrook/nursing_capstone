variable "name" {
  description = "Name of API"
}

variable "region" {
  description = "Region"
}

variable "accountId" {
  description = "Account ID"
}


variable "stage_name" {
  description = "Stage"
}

### Cognito ###
variable "user_pool" {
    description = "Admin Pool ARN"
  
}

### Cognito ###
variable "admin_pool" {
    description = "Admin Pool ARN"
  
}

### Lambdas ###
variable "get_all_pats" {
  description = "Lambda Name"
}

variable "get_all_pats_arn" {
  description = "Lambda Arn"
}

variable "get_pat" {
  description = "Lambda Name"
}

variable "get_pat_arn" {
  description = "Lambda Arn"
}

variable "upd_pat" {
  description = "Lambda Name"
}

variable "upd_pat_arn" {
  description = "Lambda Arn"
}

variable "new_pat" {
  description = "Lambda Name"
}

variable "new_pat_arn" {
  description = "Lambda Arn"
}

variable "del_pat" {
  description = "Lambda Name"
}

variable "del_pat_arn" {
  description = "Lambda Arn"
}

variable "get_all_recs" {
  description = "Lambda Name"
}

variable "get_all_recs_arn" {
  description = "Lambda Arn"
}

variable "get_rec" {
  description = "Lambda Name"
}

variable "get_rec_arn" {
  description = "Lambda Name"
}


variable "del_rec" {
  description = "Lambda Name"
}

variable "del_rec_arn" {
  description = "Lambda Name"
}

variable "new_rec" {
  description = "Lambda Name"
}

variable "new_rec_arn" {
  description = "Lambda Name"
}