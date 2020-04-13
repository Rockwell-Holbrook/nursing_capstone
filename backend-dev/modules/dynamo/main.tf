####################
# Dynamo
####################
resource "aws_dynamodb_table" "pats_db" {
  hash_key         = "id"
  name             = "${var.name}-pats_db"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "recs_db" {
  hash_key         = "id"
  name             = "${var.name}-recs_db"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "id"
    type = "S"
  }
}