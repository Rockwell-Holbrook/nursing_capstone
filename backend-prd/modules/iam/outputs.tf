output "read_pats_db_arn" {
  value = "${aws_iam_role.read_pats_db.arn}"
}

output "write_pats_db_arn" {
  value = "${aws_iam_role.write_pats_db.arn}"
}


output "read_recs_db_s3_arn" {
  value = "${aws_iam_role.read_recs_db_s3.arn}"
}


output "read_all_arn" {
  value = "${aws_iam_role.read_all.arn}"
}


output "write_all_arn" {
  value = "${aws_iam_role.write_all.arn}"
}

output "do_all_arn" {
  value = "${aws_iam_role.do_all.arn}"
}

output "recs_s3_replication" {
  value = "${aws_iam_role.recs_s3_replication.arn}"
}




