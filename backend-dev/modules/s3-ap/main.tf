####################
# S3
####################

resource "aws_s3_bucket" "recs_db_ap" {
  bucket = "${var.name}-recs-db-ap"
  region = "ap-southeast-1"
  acl      = "private"

  versioning {
    enabled = true
  }
}