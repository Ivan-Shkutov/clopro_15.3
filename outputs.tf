output "nlb_ip" {
  value = flatten([
    for l in yandex_lb_network_load_balancer.nlb.listener : [
      for e in l.external_address_spec : e.address
    ]
  ])[0]
}

output "image_url" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.images.bucket}/image.jpg"
}

output "kms_key_id" {
  value = yandex_kms_symmetric_key.bucket_key.id
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.sa_static_key.access_key
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  sensitive = true
}