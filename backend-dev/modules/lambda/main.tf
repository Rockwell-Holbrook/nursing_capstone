####################
# Lambda
####################

######## PATIENTS ########
### Get All Patients ###
# Zips the lambda #
data "archive_file" "get_all_pats" {
  type        = "zip"
  source_file = "${path.module}/code/get_all_pats.py"
  output_path = "${path.module}/zips/get_all_pats.zip"
}

# Lambda definition #
resource "aws_lambda_function" "get_all_pats" {
  function_name = "${var.name}-get_all_pats"
  filename    = data.archive_file.get_all_pats.output_path
  handler     = "get_all_pats.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.read_pats_db_arn
  source_code_hash = data.archive_file.get_all_pats.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name
    }
  }
}

### Get Patient ###
# Zips the lambda #
data "archive_file" "get_pat" {
  type        = "zip"
  source_file = "${path.module}/code/get_pat.py"
  output_path = "${path.module}/zips/get_pat.zip"
}

# Lambda definition #
resource "aws_lambda_function" "get_pat" {
  function_name = "${var.name}-get_pat"
  filename    = data.archive_file.get_pat.output_path
  handler     = "get_pat.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.read_all_arn
  source_code_hash = data.archive_file.get_pat.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}

### Update Patient ###
# Zips the lambda #
data "archive_file" "upd_pat" {
  type        = "zip"
  source_file = "${path.module}/code/upd_pat.py"
  output_path = "${path.module}/zips/upd_pat.zip"
}

# Lambda definition #
resource "aws_lambda_function" "upd_pat" {
  function_name = "${var.name}-upd_pat"
  filename    = data.archive_file.upd_pat.output_path
  handler     = "upd_pat.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.do_all_arn
  source_code_hash = data.archive_file.upd_pat.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}

### New Patient ###
# Zips the lambda #
data "archive_file" "new_pat" {
  type        = "zip"
  source_file = "${path.module}/code/new_pat.py"
  output_path = "${path.module}/zips/new_pat.zip"
}

# Lambda definition #
resource "aws_lambda_function" "new_pat" {
  function_name = "${var.name}-new_pat"
  filename    = data.archive_file.new_pat.output_path
  handler     = "new_pat.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.write_pats_db_arn
  source_code_hash = data.archive_file.new_pat.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name
    }
  }
}

### Delete Patient ###
# Zips the lambda #
data "archive_file" "del_pat" {
  type        = "zip"
  source_file = "${path.module}/code/del_pat.py"
  output_path = "${path.module}/zips/del_pat.zip"
}

# Lambda definition #
resource "aws_lambda_function" "del_pat" {
  function_name = "${var.name}-del_pat"
  filename    = data.archive_file.del_pat.output_path
  handler     = "del_pat.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.write_all_arn
  source_code_hash = data.archive_file.del_pat.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}

######## Recordings ########
### Get All Patients Recordings ###
# Zips the lambda #
data "archive_file" "get_all_recs" {
  type        = "zip"
  source_file = "${path.module}/code/get_all_recs.py"
  output_path = "${path.module}/zips/get_all_recs.zip"
}

# Lambda definition #
resource "aws_lambda_function" "get_all_recs" {
  function_name = "${var.name}-get_all_recs"
  filename    = data.archive_file.get_all_recs.output_path
  handler     = "get_all_recs.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.read_all_arn
  source_code_hash = data.archive_file.get_all_recs.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}

### Get Recording ###
# Zips the lambda #
data "archive_file" "get_rec" {
  type        = "zip"
  source_file = "${path.module}/code/get_rec.py"
  output_path = "${path.module}/zips/get_rec.zip"
}

# Lambda definition #
resource "aws_lambda_function" "get_rec" {
  function_name = "${var.name}-get_rec"
  filename    = data.archive_file.get_rec.output_path
  handler     = "get_rec.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.read_recs_db_s3_arn
  source_code_hash = data.archive_file.get_rec.output_base64sha256
  environment {
    variables = {
      S3_NAME = var.s3_name,
      RECS_DB_NAME = var.recs_db_name
    }
  }
}

### New Recording ###
# Zips the lambda #
data "archive_file" "new_rec" {
  type        = "zip"
  source_file = "${path.module}/code/new_rec.py"
  output_path = "${path.module}/zips/new_rec.zip"
}

# Lambda definition #
resource "aws_lambda_function" "new_rec" {
  function_name = "${var.name}-new_rec"
  filename    = data.archive_file.new_rec.output_path
  handler     = "new_rec.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.do_all_arn
  source_code_hash = data.archive_file.new_rec.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}

### Delete Recording ###
# Zips the lambda #
data "archive_file" "del_rec" {
  type        = "zip"
  source_file = "${path.module}/code/del_rec.py"
  output_path = "${path.module}/zips/del_rec.zip"
}

# Lambda definition #
resource "aws_lambda_function" "del_rec" {
  function_name = "${var.name}-del_rec"
  filename    = data.archive_file.del_rec.output_path
  handler     = "del_rec.lambda_handler"
  runtime     = "python3.6"
  timeout     = "30"
  memory_size = var.memory_size
  role        = var.do_all_arn
  source_code_hash = data.archive_file.del_rec.output_base64sha256
  environment {
    variables = {
      PATS_DB_NAME = var.pats_db_name,
      RECS_DB_NAME = var.recs_db_name,
      S3_NAME = var.s3_name
    }
  }
}