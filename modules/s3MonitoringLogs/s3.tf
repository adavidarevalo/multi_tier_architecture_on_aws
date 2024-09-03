resource "random_string" "key" {
  length  = 5
  special = false
}

module "monitoring_bucket_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "App102309234Logs"
  force_destroy            = true
  object_lock_enabled      = true
  control_object_ownership = true
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
