variable "folder_id" {
  description = "ID папки Yandex.Cloud"
  type        = string
}

variable "cloud_id" {
  description = "ID облака Yandex.Cloud"
  type        = string
}

variable "public_ssh_key" {
  description = "Публичный SSH ключ для доступа к ВМ"
  type        = string
}

variable "private_ssh_key" {
  description = "Приватный SSH ключ для подключения к ВМ"
  type        = string
}

variable "zone" {
  description = "Зона для размещения ресурсов"
  type        = string
  default     = "ru-central1-a"
}

variable "bucket_name" {
  description = "Имя бакета Object Storage"
  type        = string
  default     = "shkutov-20260321"
}