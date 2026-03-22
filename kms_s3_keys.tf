resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = "aje3opmc4apav6fmu8bs"
  description        = "Static key for Object Storage"
}