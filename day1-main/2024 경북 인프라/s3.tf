resource "aws_kms_key" "s3" {
  key_usage = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7

  tags = {
    Name = "s3-kms"
  }
}

resource "aws_kms_alias" "s3" {
  target_key_id = aws_kms_key.s3.key_id
  name = "alias/s3-kms"
}

resource "aws_s3_bucket" "s3" {
  bucket = "apne2-wsi-static-101"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3.arn
        sse_algorithm = "aws:kms"
      }
    }
  }

    tags = {
        Name = "apne2-wsi-static-101"
    }
}

resource "aws_s3_bucket_object" "static_folder" {
  bucket = aws_s3_bucket.s3.bucket
  key = "static/"
}

resource "aws_s3_object" "static" {
  bucket = aws_s3_bucket.s3.id
  key    = "/static/index.html"
  source = "./src/index.html"
  etag   = filemd5("./src/index.html")
  content_type = "text/html"
}

output "s3" {
    value = aws_s3_bucket.s3.id
}