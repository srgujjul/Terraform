#---------storage/main.tf---------

# Create a random uuid
resource "random_uuid" "tf_bucket_id" {
}

# Create the bucket
resource "aws_s3_bucket" "tf_code" {
  bucket = "${substr(random_uuid.tf_bucket_id.result, 25, 12)}-${var.bucket_name}"
  acl    = "private"

  force_destroy = true

  tags = {
    Name = "tf_bucket"
  }
}

