resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "bucket-encryption-key"
  description       = "KMS key для шифрования бакета"
  folder_id         = var.folder_id
  default_algorithm = "AES_128"
  rotation_period   = "2160h"  # ротация каждые 90 дней
}