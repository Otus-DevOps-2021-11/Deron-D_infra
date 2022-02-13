terraform {
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "otus-deron-d-bucket"
    region   = "ru-central1-a"
    key      = "terraform.tfstate"
    # access_key = var.access_key
    # secret_key = var.secret_key
    # access_key                  = "access_key"
    # secret_key                  = "secret_key"
    access_key               = "dp5D8zGUyPs-NGWbtuAB"
    secret_key               = "CtMHQHpU7kt7ijPHZceTPlAtwCiwK2wtjYfS7wW9"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
