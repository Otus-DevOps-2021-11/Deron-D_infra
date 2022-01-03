terraform {
  required_version = "0.12.8"
}

provider "yandex" {
  version                  = "0.35"
  service_account_key_file = pathexpand("~/.yc_keys/key.json")
  folder_id                = "b1gu87e4thvariradsue"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "app" {
  name = "reddit-app"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашнем задании
      image_id = "fd8190armqc6lvi7l8bq"
    }
  }
  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = "e9bogf7vjavut5hrqrjl"
    nat       = true
  }
}
