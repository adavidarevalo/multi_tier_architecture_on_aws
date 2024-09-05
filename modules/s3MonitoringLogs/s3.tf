resource "random_id" "s3_suffix" {
  byte_length = 4
}

module "monitoring_bucket_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = format("%s-%s-%s-%s", "myapp", "prod", "us-east-1", random_id.s3_suffix.hex)

  force_destroy            = true
  object_lock_enabled      = true
  control_object_ownership = true

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = false
  restrict_public_buckets = false

  lifecycle_rule = [
    {
      id      = "log"
      enabled = true

      filter = {
        tags = {
          some    = "value"
          another = "value2"
        }
      }

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
    },
  ]
  
  tags = var.tags
}

resource "aws_s3_bucket_policy" "monitoring_bucket_policy" {
  bucket = module.monitoring_bucket_logs.s3_bucket_id

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "${module.monitoring_bucket_logs.s3_bucket_arn}/*",
      "Principal": "*"
    }
  ]
})
}
