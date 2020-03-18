 
 # --------------------------------------------------------------
# Setup Provider
# ---------------------------------------------------------------
 provider "aws" {
   region = "us-east-1"
   profile = "sharemyhub"
 }

 module "s3" {
   source = "./s3"
   bucket_name = "zazu-s3-bucket"
   acl = "private"
 }

  module "s3_policy" {
   source = "../modules/s3"
   bucket_name = "zazu-s3-bucket"
   bucket_id = "${module.s3.id}"
 }

  module "lambda" {
    source = "../modules/lambda"
   function_name = "ServerlessExample"
   function_file = "../../lambda/dist/example.zip"
   handler = "index.handler"
   node_version = "nodejs10.x"
   lambda_exec_name = "serverless_example_lambda"
 }