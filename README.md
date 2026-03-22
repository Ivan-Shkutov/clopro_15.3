## Домашнее задание к занятию «Безопасность в облачных провайдерах»

## Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

### Задание 1. Yandex Cloud

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:
   
  - создать ключ в KMS;
    
  - с помощью ключа зашифровать содержимое бакета, созданного ранее.



- - - - -

### Решение

```
# Инициализация Terraform
terraform init


# Проверка конфигурации
terraform validate


# Планирование изменений
terraform plan


# Применение конфигурации
terraform apply


# Настройка переменных окружения для доступа к Yandex S3
export AWS_ACCESS_KEY_ID=$(terraform output -raw access_key)
export AWS_SECRET_ACCESS_KEY=$(terraform output -raw secret_key)
export AWS_DEFAULT_REGION=ru-central1


# Проверка бакета
aws s3 ls --endpoint-url https://storage.yandexcloud.net


# Создание KMS ключа - kms.tf
resource "yandex_kms_symmetric_key" "images_key" {
  name              = "images-symmetric-key"
  description       = "KMS key for encrypting storage bucket"
  default_algorithm = "AES_128"
  rotation_period   = "2160h" # 90 дней
}


# Добавление в Terraform. Ключ будет использоваться для серверного шифрования объектов в бакете. rotation_period = "2160h" означает ротацию каждые 90 дней.
terraform apply


# Настройка шифрования бакета через Terraform - storage.tf
resource "yandex_storage_bucket" "images" {
  bucket        = var.bucket_name
  folder_id     = var.folder_id
  acl           = "public-read"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.images_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}



# Добавление в Terraform
terraform apply


# Перезагрузка существующих объектов для применения KMS. Перезагружает объекты в том же бакете, чтобы KMS шифрование применилось к существующим файлам.
aws s3 cp s3://shkutov-20260321/image.jpg s3://shkutov-20260321/image.jpg \
    --endpoint-url https://storage.yandexcloud.net
	

# Проверка, что объект зашифрован KMS
yc storage s3api head-object \
  --bucket shkutov-20260321 \
  --key image.jpg
  
etag: '"a194d0b5896a12b679f6776b5e50c55f"'
request_id: 6405beb18ffc175b
accept_ranges: bytes
content_length: "211055"
content_type: image/jpeg
last_modified_at: "2026-03-22T12:34:18Z"
server_side_encryption: aws:kms
sse_kms_key_id: abjjt8qa33b3g87fsqfb


 
# Перезагрузка объектов, применить шифрование к существующим файлам
aws s3api head-object \
    --bucket shkutov-20260321 \
    --key image.jpg \
    --endpoint-url https://storage.yandexcloud.net

{
    "AcceptRanges": "bytes",
    "LastModified": "2026-03-22T12:34:18+00:00",
    "ContentLength": 211055,
    "ETag": "\"a194d0b5896a12b679f6776b5e50c55f\"",
    "ContentType": "image/jpeg",
    "ServerSideEncryption": "aws:kms",
    "Metadata": {},
    "SSEKMSKeyId": "abjjt8qa33b3g87fsqfb"
}
 
 
  
# Проверка работы сайта
curl -I https://storage.yandexcloud.net/shkutov-20260321/image.jpg

HTTP/2 200 
server: nginx
date: Sun, 22 Mar 2026 12:43:37 GMT
content-type: image/jpeg
content-length: 211055
accept-ranges: bytes
etag: "a194d0b5896a12b679f6776b5e50c55f"
last-modified: Sun, 22 Mar 2026 12:34:18 GMT
x-amz-request-id: a4b029a3551a77dc
x-amz-server-side-encryption: aws:kms
x-amz-server-side-encryption-aws-kms-key-id: abjjt8qa33b3g87fsqfb



# Итоговая проверка
terraform output — получить ключи и KMS ID
yc storage s3api head-object — проверить шифрование
aws s3 cp - применить шифрование к существующим файлам
curl -I https://storage.yandexcloud.net/shkutov-20260321/image.jpg - публичный доступ и убедиться, что файлы доступны

```

[1!](https://github.com/Ivan-Shkutov/clopro_15.3/blob/main/img/1.png)






- - - - -

