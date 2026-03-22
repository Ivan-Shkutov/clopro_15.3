resource "yandex_storage_bucket" "images" {
  bucket        = var.bucket_name
  folder_id     = var.folder_id
  acl           = "public-read"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "image" {
  bucket       = yandex_storage_bucket.images.bucket
  key          = "image.jpg"
  source       = "image.jpg"
  content_type = "image/jpeg"
  acl          = "public-read"
}