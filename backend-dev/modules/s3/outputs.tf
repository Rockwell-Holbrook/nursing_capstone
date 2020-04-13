output "recs_s3_us" {
  value = "${aws_s3_bucket.recs_db_us.arn}"
}

output "recs_s3_name_us" {
  value = "${aws_s3_bucket.recs_db_us.id}"
}