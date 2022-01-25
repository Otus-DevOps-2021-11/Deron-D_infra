terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "deron-d"
    region   = "ru-central1-a"
    key      = "terraform.tfstate"
    # access_key = var.access_key
    # secret_key = var.secret_key
    access_key               = "K4TtqtWGIRVL5zmwZXW5"
    secret_key               = "V77vOvVzHpU8mZhLoorFUKP7D8T5O6o2f1irXTwP"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
