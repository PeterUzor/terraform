variable "bucket_name" {
  default = "zazu-s3-bucket"
}

variable "acl" {
  default = "private"
}

# --------------------------------------------------------------
# Setup S3 Bucket
# ---------------------------------------------------------------
resource "aws_s3_bucket" "b" {
  bucket = "${var.bucket_name}"
  acl    = "${var.acl}"
}

output "id" {
  value = "${aws_s3_bucket.b.id}"
}