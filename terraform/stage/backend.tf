terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "deron-d"
    region   = "ru-central1-a"
    key      = "terraform.tfstate"
    # access_key = var.access_key
    # secret_key = var.secret_key
    access_key                  = "access_key"
    secret_key                  = "secret_key"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
