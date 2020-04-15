####################
# Dynamo
####################
resource "aws_dynamodb_global_table" "pats_db" {

  name = "${var.name}-pats_db"

  replica {
    region_name = "us-west-2"
  }

  replica {
    region_name = "ap-southeast-1"
  }
}


resource "aws_dynamodb_global_table" "recs_db" {

  name = "${var.name}-recs_db"

  replica {
    region_name = "us-west-2"
  }

  replica {
    region_name = "ap-southeast-1"
  }
}