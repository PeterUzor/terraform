
variable "function_name" {
  default = "ServerlessExample"
}

variable "function_file" {
  default = "../lambda/dist/example.zip"
}

variable "handler" {
  default = "index.handler"
}

variable "node_version" {
  default = "nodejs10.x"
}
variable "lambda_exec_name" {
  default = "serverless_example_lambda"
}

# --------------------------------------------------------------
# Step 1: Setup Lambda function resource
# --------------------------------------------------------------- 
 resource "aws_lambda_function" "lambda" {
   function_name = "${var.function_name}"
   filename = "${var.function_file}"
   # The bucket name as created earlier with "aws s3api create-bucket"

   # "main" is the filename within the zip file (main.js) and "handler"
   # is the name of the property under which the handler function was
   # exported in that file.
   handler = "${var.handler}"
   runtime = "${var.node_version}"

   role = "${aws_iam_role.lambda_exec.arn}"
 }

# --------------------------------------------------------------
# Step 2: IAM role which dictates what other AWS services the Lambda function
# may access
# ---------------------------------------------------------------
 resource "aws_iam_role" "lambda_exec" {
   name = "${var.lambda_exec_name}"
   assume_role_policy = "${data.aws_iam_policy_document.lambda_assume.json}"
 }

  resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = "${aws_lambda_function.lambda.function_name}"
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${module.apigateway.execution_arn}/*/*"
 }

 data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

  module "apigateway" {
   source = "../api-gateway"
   gateway_name = "zazuApiGateway"
   gateway_description = "Testing 123"
   http_method = "POST"
   authorization = "NONE"
   invoke_arn = "${aws_lambda_function.lambda.invoke_arn}"
 }