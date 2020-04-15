####################
# S3
####################

resource "aws_s3_bucket" "recs_db_us" {
  bucket   = "${var.name}-recs-db-us"
  acl      = "private"
  region   = "us-west-2"

  versioning {
    enabled = true
  }

  replication_configuration {
    role = var.recs_s3_replication

    rules {
      id     = "foobar"
      prefix = "foo"
      status = "Enabled"

      destination {
        bucket        = var.recs_db_s3_arn
        storage_class = "STANDARD"
      }
    }
  }
}