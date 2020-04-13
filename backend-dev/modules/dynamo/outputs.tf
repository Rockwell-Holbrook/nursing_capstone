output "pats_db" {
  value = "${aws_dynamodb_table.pats_db.arn}"
}

output "recs_db" {
  value = "${aws_dynamodb_table.recs_db.arn}"
}

output "pats_db_name" {
  value = "${aws_dynamodb_table.pats_db.name}"
}

output "recs_db_name" {
  value = "${aws_dynamodb_table.recs_db.name}"
}