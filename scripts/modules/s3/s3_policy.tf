variable "bucket_name" {
  default = "zazu-s3-bucket"
}

variable "bucket_id" {
  default = ""
}

# --------------------------------------------------------------
# Setup S3 Bucket policy
# ---------------------------------------------------------------
resource "aws_s3_bucket_policy" "b" {
  bucket = "${var.bucket_id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "S3BUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}