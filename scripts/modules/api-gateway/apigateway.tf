
variable "gateway_name" {
  default = "zazuApiGateway"
}

variable "gateway_description" {
  default = ""
}

variable "http_method" {
  default = "POST"
}

variable "authorization" {
  default = "NONE"
}

variable "invoke_arn" {
  default = "aws_lambda_function.lambda.invoke_arn"
}

# --------------------------------------------------------------
# Step 1 : Create APIGateway
# ---------------------------------------------------------------
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.gateway_name}"
  description = "${var.gateway_description}"
}

# --------------------------------------------------------------
# Step 2 : Create APIGateway Resource
# ---------------------------------------------------------------
resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

# --------------------------------------------------------------
# Step 3 : Create Method Request
# ---------------------------------------------------------------
resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
  request_models = {
    "application/json" = "Error"
  }
}

# --------------------------------------------------------------
# Step 4: Route API Gateway Request to Lambda (Create Integration Request)
# ---------------------------------------------------------------
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "${var.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "${var.invoke_arn}"
  request_templates = {
    "application/json" = ""
  }
}

output "execution_arn" {
  value = "${aws_api_gateway_rest_api.api.execution_arn}"
}