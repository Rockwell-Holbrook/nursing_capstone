output "recs_s3_ap" {
  value = "${aws_s3_bucket.recs_db_ap.arn}"
}

output "recs_s3_name_ap" {
  value = "${aws_s3_bucket.recs_db_ap.id}"
}

