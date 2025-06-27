data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}
 resource "aws_s3_bucket" "name" {
   bucket = "prsnlakshmi"
 }
# Upload Lambda ZIP to S3
resource "aws_s3_object" "lambda_code" {
  bucket = "prsnlakshmi"
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path  # Ensure this file exists in your local directory
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
  depends_on = [data.archive_file.lambda_zip]
}
resource "aws_lambda_function" "my_lambda" {
  function_name    = "my_lambda_function"
  role            = data.aws_iam_role.existing_lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.9"
  
  s3_bucket     = "prsnlakshmi"
  s3_key        = "lambda_function.zip"
}
data "aws_iam_role" "existing_lambda_role" {
  name = "lambda_s3_execution_role"
}

data "aws_iam_policy" "existing_lambda_policy" {
  name = "lambda_s3_access_policy"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  policy_arn = data.aws_iam_policy.existing_lambda_policy.arn
  role       = data.aws_iam_role.existing_lambda_role.name
}
