output "get_all_pats" {
  value = "${aws_lambda_function.get_all_pats.function_name}"
}

output "get_all_pats_arn" {
  value = "${aws_lambda_function.get_all_pats.invoke_arn}"
}

output "get_pat" {
  value = "${aws_lambda_function.get_pat.function_name}"
}

output "get_pat_arn" {
  value = "${aws_lambda_function.get_pat.invoke_arn}"
}

output "upd_pat" {
  value = "${aws_lambda_function.upd_pat.function_name}"
}

output "upd_pat_arn" {
  value = "${aws_lambda_function.upd_pat.invoke_arn}"
}

output "new_pat" {
  value = "${aws_lambda_function.new_pat.function_name}"
}

output "new_pat_arn" {
  value = "${aws_lambda_function.new_pat.invoke_arn}"
}

output "del_pat" {
  value = "${aws_lambda_function.del_pat.function_name}"
}

output "del_pat_arn" {
  value = "${aws_lambda_function.del_pat.invoke_arn}"
}

output "get_all_recs" {
  value = "${aws_lambda_function.get_all_recs.function_name}"
}

output "get_all_recs_arn" {
  value = "${aws_lambda_function.get_all_recs.invoke_arn}"
}

output "get_rec" {
  value = "${aws_lambda_function.get_rec.function_name}"
}

output "get_rec_arn" {
  value = "${aws_lambda_function.get_rec.invoke_arn}"
}

output "new_rec" {
  value = "${aws_lambda_function.new_rec.function_name}"
}

output "new_rec_arn" {
  value = "${aws_lambda_function.new_rec.invoke_arn}"
}

output "del_rec" {
  value = "${aws_lambda_function.del_rec.function_name}"
}

output "del_rec_arn" {
  value = "${aws_lambda_function.del_rec.invoke_arn}"
}