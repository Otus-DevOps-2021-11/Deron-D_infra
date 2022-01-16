# **Лекция №4: Локальное окружение инженера. ChatOps и визуализация рабочих процессов. Командная работа с Git. Работа в GitHub**
> _play-travis_
<details>
  <summary>Настройка локального окружения и практика ChatOps</summary>

## **Задание:**
Настройка локального окружения и практика ChatOps.

Цель:
В данном дз студент продолжает знакомство в GIT. Студент настроит репозиторий, сделает интеграцию с Travic CI и Slack.
В данном задании тренируются навыки: работы с GIT, настройки интеграций с различными источниками.

Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**
1. Клонирование своего репозитория
```
git clone git@github.com:Otus-DevOps-2021-11/Deron-D_infra.git
```

2. Работа с ветками
```
cd Deron-D_infra
git checkout -b play-travis
```

3. Добавление изменений. Функционал Pull Request Templates.
```
mkdir .github
cd .github
wget http://bit.ly/otus-pr-template -O PULL_REQUEST_TEMPLATE.md
cd ..
```
4. Добавим функционал хука pre-commit

- Выполним команды
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py & python3 get-pip.py
sudo pip3 install pre-commit
```

- Создадим в репозитории файл [.pre-commit-config.yaml](.pre-commit-config.yaml) со следующим содержимым
```
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
```
- Выполним команду
```
pre-commit install
pre-commit installed at .git/hooks/pre-commit
```

5. Отправим изменения:
```
git add .
git commit -am 'Add PR template'
git push --set-upstream origin play-travis
```
6. Настройка интеграций используемых сервисов с чатом

- Создадим канал [#dmitriy_pnev](https://devops-team-otus.slack.com/archives/CN8RWNKQR)

- Интеграция с GitHub
Наберем в своем канале Slack команду-сообщение:
```
/github subscribe Otus-DevOps-2021-11/Deron-D_infra commits:*
```

- Тестируем интеграцию
```
mkdir play-travis
cd play-travis
wget https://raw.githubusercontent.com/express42/otus-snippets/master/hw-04/test.py
cd ..
```

- Правим ошибку в test.py
```
sed -i 's/self.assertEqual(1 + 1, 1)/self.assertEqual(1 + 1, 2)/' play-travis/test.py
```

- Сделаем коммит этого файла в ветку play-travis нашего  репозитория на GitHub
```
git status
git add .
git commit -am 'Add test.py'
git push --set-upstream origin play-travis
```
- Проверяем, что в наш канал [#dmitriy_pnev](https://devops-team-otus.slack.com/archives/CN8RWNKQR) приходят уведомления о новых коммитах

7. Настройка функционала Github Actions
```
mkdir -p .github/workflows/
cd .github/workflows/
wget https://raw.githubusercontent.com/Otus-DevOps-2020-11/.github/main/workflow-templates/auto-assign.yml
wget https://gist.githubusercontent.com/mrgreyves/43311631626a5f0b471dff45203c52e2/raw/5f3fb777607d335852084c2c9a5a0f52773cf4e8/run-tests.yml
cd ..
wget https://gist.githubusercontent.com/mrgreyves/d8815bcb7e00a2f0b26d0e0a48c5563b/raw/f4a76a7842f6c7cd5e428db6b33938fb1dffcbf4/auto_assign.yml
```


## **Полезное:**
</details>

# **Лекция №5: Знакомство с облачной инфраструктурой Yandex.Cloud**
> _cloud-bastion_
<details>
  <summary>Знакомство с облачной инфраструктурой</summary>

## **Задание:**
Запуск VM в Yandex Cloud, управление правилами фаервола, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка $

Цель:
В данном дз студент создаст виртуальные машины в Yandex.Cloud. Настроит bastion host и ssh. В данном задании тренируются навыки: создания ви$

Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено 1 б. - задание выполнено 2 б. - выполнены все дополнительные задания

bastion_IP = 84.252.136.193
someinternalhost_IP = 10.129.0.25
---

## **Выполнено:**
1. Создаем инстансы VM bastion и someinternalhost через веб-морду Yandex.Cloud

2. Генерим пару ключей
```bash
ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""
```

3. Проверяем подключение по полученному внешнему адресу
```bash
➜  Deron-D_infra git:(cloud-bastion) ssh -i ~/.ssh/appuser appuser@84.252.136.193
The authenticity of host '84.252.136.193 (84.252.136.193)' can't be established.
ECDSA key fingerprint is SHA256:ZiHfHm3LdK0MGjvw30kTB9a3IMfem/fBmX7S3BcVprI.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '84.252.136.193' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

appuser@bastion:~$ exit
logout
Connection to 84.252.136.193 closed.
```

4. Пробуем зайти по SSH на bastionhost , а с него по внутреннему адресу на someinternalhost
```bash
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh -i ~/.ssh/appuser appuser@84.252.136.193
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Sun Dec 19 12:47:30 2021 from 82.194.224.170
appuser@bastion:~$ ping 10.129.0.25
PING 10.129.0.25 (10.129.0.25) 56(84) bytes of data.
64 bytes from 10.129.0.25: icmp_seq=1 ttl=63 time=1.11 ms
64 bytes from 10.129.0.25: icmp_seq=2 ttl=63 time=0.390 ms
^C
--- 10.129.0.25 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.390/0.751/1.113/0.361 ms
appuser@bastion:~$ ssh 10.129.0.25
The authenticity of host '10.129.0.25 (10.129.0.25)' can't be established.
ECDSA key fingerprint is SHA256:FlXAZUZ4ePBdhUANM+ZSCUHt3ZladtNOcYfHuHmxyKo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.129.0.25' (ECDSA) to the list of known hosts.
appuser@10.129.0.25: Permission denied (publickey).
```

5. Используем Bastion host для прямого подключения к инстансам внутренней сети:
- Настроим SSH Forwarding на нашей локальной машине:
```bash
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh-add -L
Could not open a connection to your authenticati~/otus-devops/Deron-D_infra $ ssh-add ~/.ssh/appuser
Identity added: /home/dpp/.ssh/appuser (appuser)
 ~/otus-devops/Deron-D_infra $ eval $(ssh-agent -s)
Agent pid 1739595 on agent.
```
- Добавим приватный ключ в ssh агент авторизации:
```bash
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh-add -L
The agent has no identities.
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh-add ~/.ssh/appuser
Identity added: /home/dpp/.ssh/appuser (appuser)
```

- Проверяем прямое подключение:
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh -i ~/.ssh/appuser -A appuser@84.252.136.193
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Last login: Sun Dec 19 13:38:52 2021 from 82.194.224.170
appuser@bastion:~$ ssh 10.129.0.25
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

appuser@someinternalhost:~$ hostname
someinternalhost
appuser@someinternalhost:~$ ip a show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:cf:b3:c9:a7 brd ff:ff:ff:ff:ff:ff
    inet 10.129.0.25/24 brd 10.129.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::d20d:cfff:feb3:c9a7/64 scope link
       valid_lft forever preferred_lft forever
```

- Проверим отсутствие каких-либо приватных ключей на bastion машине:
```
appuser@someinternalhost:~$ ls -la ~/.ssh/
total 12
drwx------ 2 appuser appuser 4096 Dec 19 13:01 .
drwxr-xr-x 4 appuser appuser 4096 Dec 19 13:58 ..
-rw------- 1 appuser appuser  561 Dec 19 13:01 authorized_keys
```

- Самостоятельное задание. Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства:

Добавим в ~/.ssh/config содержимое:
```bash
➜  Deron-D_infra git:(cloud-bastion) ✗ cat ~/.ssh/config
Host 84.252.136.193
  User appuser
  IdentityFile /home/dpp/.ssh/appuser
Host 10.129.0.25
  User appuser
  ProxyCommand ssh -W %h:%p 84.252.136.193
  IdentityFile /home/dpp/.ssh/appuser
```
- Проверяем работоспособность найденного решения:
```bash
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh 10.129.0.25
The authenticity of host '10.129.0.25 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:FlXAZUZ4ePBdhUANM+ZSCUHt3ZladtNOcYfHuHmxyKo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.129.0.25' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Dec 19 13:58:50 2021 from 10.129.0.34
```

- Дополнительное задание:

На локальной машине правим /etc/hosts
```bash
sudo bash -c 'echo "10.129.0.25 someinternalhost" >> /etc/hosts'
```

Добавим в ~/.ssh/config содержимое:
```bash
Host someinternalhost
  User appuser
  ProxyCommand ssh -W %h:%p 84.252.136.193
  IdentityFile /home/dpp/.ssh/appuser
```

Проверяем:
```
➜  Deron-D_infra git:(cloud-bastion) ✗ ssh someinternalhost
The authenticity of host 'someinternalhost (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:FlXAZUZ4ePBdhUANM+ZSCUHt3ZladtNOcYfHuHmxyKo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'someinternalhost' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Sun Dec 19 14:22:10 2021 from 10.129.0.34
```
- Создаем VPN-сервер для серверов Yandex.Cloud:

Создан скрипт установки VPN-сервера (setupvpn.sh)[./setupvpn.sh]

[Веб-интерфейс VPN-сервера Pritunl](https://84-252-136-193.sslip.io/#dashboard)


## **Полезное:**
- [SSH: подключение в приватную сеть через Bastion и немного про Multiplexing](https://rtfm.co.ua/ssh-podklyuchenie-v-privatnuyu-set-cherez-$
</details>


# **Лекция №6: Основные сервисы Yandex Cloud**
> _cloud-testapp_
<details>
  <summary>Практика управления ресурсами yandex cloud через yc.</summary>

## **Задание:**
Цель:
В данном дз произведет ручной деплой тестового приложения. Напишет bash скрипт для автоматизации задач настройки VM и деплоя приложения.
В данном задании тренируются навыки: деплоя приложения на сервер, написания bash скриптов.

Ручной деплой тестового приложения. Написание bash скриптов для автоматизации задач настройки VM и деплоя приложения.
Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

testapp_IP = 51.250.0.68
testapp_port = 9292

---

## **Выполнено:**
- Установлен YC CLI:
```bash
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

- Проверена работа YC CLI:
```bash
➜  Deron-D_infra git:(cloud-testapp) ✗ yc config list
token: AQA..
cloud-id: b1g...
folder-id: b1g...
compute-default-zone: ru-central1-a
➜  Deron-D_infra git:(cloud-testapp) ✗ yc config profile list
default ACTIVE
```

- Создан новый инстанс reddit-app [create_instance.sh](./create_instance.sh):
```bash
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --ssh-key ~/.ssh/appuser.pub
```

- Установлен Ruby [install_ruby.sh](./install_ruby.sh):
```
#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
```

- Проверен Ruby и Bundler:
```
$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
$ bundler -v
Bundler version 1.11.2
```

- Установлен и запущен MongoDB [install_mongodb.sh](./install_mongodb.sh):
```
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates

sudo apt-get update
sudo apt-get install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
```

- Выполнен деплой приложения [deploy.sh](./deploy.sh):
```
sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
```

- Дополнительное задание:

Для создания инстанса с развернутым приложением достаточно запустить:
```
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata-from-file user-data=metadata.yaml \
 --metadata serial-port-enable=1
```

Содержимое [metadata.yaml](./metadata.yaml):
```
#cloud-config
users:
  - default
  - name: yc-user
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUSGRF2QvKndsn1hbFv93CgS3/AiwCoETwjHL6Wzkyape+sW5EXKT/MXjCTlBVfqPtKWvY2pqXpEY7oJAOmJJrBvwnuod2SzEEoFncK1YOLXJOhzeXkT1+1cgo27jJYb4TQTWjawCYv48kJnPNwSL/jNLGQSdosfH3POQVWkB3xCjoLZ7/kMqZQbFEvol5BI5T0HM7uKtPJdWUPD0X1Jpu5MgFV6ZmSWWVrGY25nTehs0nTy4AkAv5mp8VJQtzpKu+fennhQdeb+8aGEaZkFNUOGFAf9ph0G4Lq/gks491Un7cL1/HvcRgPvDdqS+ZRKaPopqK/f978VkpzovlZNJWERZyTrzbgkme6x88zv+rWUu3DiWhldGNuBdghA2kOGhSpSX80gLlj8yE3IP8pdveOq10OztLVpy+8j7tSegOdU9QnBNZ/wqgSVa9kWCU/fui4ASDAA4IAWtthUkaqmDdSPM8mPv8KYueR75LOPKMCCclAOz8S8LK1kFRwcJVEs8= appuser"

runcmd:
  - wget https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/cloud-testapp/bootstrap.sh
  - bash bootstrap.sh
```

Содержимое [bootstrap.sh](./bootstrap.sh):
```
#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates ruby-full ruby-bundler build-essential mongodb-org git
sudo systemctl --now enable mongod
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```

# **Полезное:**
</details>

# **Лекция №7: Модели управления инфраструктурой. Подготовка образов с помощью Packer**
> _packer-base_
<details>
  <summary>Подготовка базового образа VM при помощи Packer</summary>

## **Задание:**
Подготовка базового образа VM при помощи Packer.

Цель:
В данном дз студент произведет сборку готового образа с уже установленным приложением при помощи Packer. Задеплоит приложение в Yandex compute cloud при помощи ранее подготовленного образа.
В данном задании тренируются навыки: работы с Packer, работы с YC.

Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**

1. Установлен Packer:

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
➜  Deron-D_infra git:(packer-base) packer -v
1.7.8
```

2.1. Создан сервисный аккаунт:
```bash
SVC_ACCT="svcuser"
FOLDER_ID=$(yc config list | grep folder-id | cut -d ' ' -f 2)
➜  Deron-D_infra git:(packer-base) yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
id: aje0m03rhn6s1lq4un9a
folder_id: b1gu87e4thvariradsue
created_at: "2021-12-30T21:37:09.317555534Z"
name: svcuser
```

2.2. Делегированы права editor сервисному аккаунту для Packer
```bash
ACCT_ID=$(yc iam service-account get $SVC_ACCT | grep ^id | awk '{print $2}')
➜  Deron-D_infra git:(packer-base) ✗ yc resource-manager folder add-access-binding --id $FOLDER_ID --role editor --service-account-id $ACCT_ID
done (1s)
```

2.3. Создан service account key file
```bash
➜  Deron-D_infra git:(packer-base) ✗ yc iam key create --service-account-id $ACCT_ID --output ~/.yc_keys/key.json
id: ajeovakc635hscjpiv3t
service_account_id: aje0m03rhn6s1lq4un9a
created_at: "2022-01-02T17:00:57.913576072Z"
key_algorithm: RSA_2048

➜  Deron-D_infra git:(packer-base) ✗ ll ~/.yc_keys
итого 8,0K
-rw-------. 1 dpp dpp 2,4K янв  2 20:00 key.json
```

3. Создан файла-шаблона Packer [ubuntu16.json](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/ubuntu16.json)

4. Созданы скрипты для provisioners [install_ruby.sh](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/scripts/install_ruby.sh);[install_mongodb.sh](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/scripts/install_mongodb.sh)

5. Выполнено параметризирование шаблона с применением [variables.json.example](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/variables.json.example)

6. Выполнена проверка на ошибки
```bash
➜  packer git:(packer-base) ✗ packer validate -var-file=./variables.json ./ubuntu16.json
The configuration is valid.
```

7. Произведен запуск сборки образа
```bash
packer build -var-file=./variables.json ./ubuntu16.json
```

8. Создана ВМ с использованием созданного образа

9. Выполнено "дожаривание" ВМ для запуска приложения:
```bash
sudo apt-get update
sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
```

10. Построение bake-образа `*`
- Создан [immutable.json](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/immutable.json)
- Создан systemd unit [puma.service](https://raw.githubusercontent.com/Otus-DevOps-2021-11/Deron-D_infra/packer-base/packer/files/puma.service)
- Запущена сборка
```
packer build -var-file=./variables.json immutable.json
```
- Проверка созданных образов:
```bash
➜  packer git:(packer-base) ✗ yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd8h54ao679l7j00kmi7 | reddit-base-1641146829 | reddit-base | f2eprbl75mtak72k76c5 | READY  |
| fd8vb8lcmbe116i8umkc | reddit-full-1641149015 | reddit-full | f2eprbl75mtak72k76c5 | READY  |
+----------------------+------------------------+-------------+----------------------+--------+
```

11. Автоматизация создания ВМ `*`
- Создан [create-reddit-vm.sh](./config-scripts/create-reddit-vm.sh)


# **Полезное:**
</details>

# **Лекция №8: Знакомство с Terraform**
> _terraform-1_
<details>
 <summary>Знакомство с Terraform</summary>

## **Задание:**
Декларативное описание в виде кода инфраструктуры YC, требуемой для запуска тестового приложения, при помощи Terraform.

Цель:
В данном дз студент опишет всю инфраструктуру в Yandex Cloud при помощи Terraform.
В данном задании тренируются навыки: создания и описания инфраструктуры при помощи Terraform. Принципы и подходы IaC.

Все действия описаны в методическом указании.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**
1. Установлен terraform 0.12.8 с помощью [terraform-switcher](https://github.com/warrensbox/terraform-switcher)

```bash
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash

➜  Deron-D_infra git:(terraform-1) ✗ tfswitch
Use the arrow keys to navigate: ↓ ↑ → ←
? Select Terraform version:
  ▸ 0.12.8 *recent

terraform git:(terraform-1) ✗ terraform -v
Terraform v0.12.8
```

2. В корне репозитория дополнили файл [.gitignore](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-1/.gitignore) содержимым:

```github
*.tfstate
*.tfstate.*.backup
*.tfstate.backup
*.tfvars
.terraform/
```

3. Узнаем свои параметры токена, идентификатора облака и каталога:

```bash
yc config list
➜  Deron-D_infra git:(terraform-1) ✗ yc config list
token: <OAuth или статический ключ сервисного аккаунта>
cloud-id: <идентификатор облака>
folder-id: <идентификатор каталога>
compute-default-zone: ru-central1-a
```

4. Создадим сервисный аккаунт для работы terraform:

```bash
FOLDER_ID=$(yc config list | grep folder-id | awk '{print $2}')
SRV_ACC=trfuser

yc iam service-account create --name $SRV_ACC --folder-id $FOLDER_ID

SRV_ACC_ID=$(yc iam service-account get $SRV_ACC | grep ^id | awk '{print $2}')

yc resource-manager folder add-access-binding --id $FOLDER_ID --role editor --service-account-id $SRV_ACC_ID

yc iam key create --service-account-id $SRV_ACC_ID --output ~/.yc_keys/key.json
```

5. Смотрим информацию о имени, семействе и id пользовательских образов своего каталога с помощью команды yc compute image list:

```bash
➜  Deron-D_infra git:(terraform-1) yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd8190armqc6lvi7l8bq | reddit-base-1641220903 | reddit-base | f2ejt2v5v2gt4lfcs9gb | READY  |
+----------------------+------------------------+-------------+----------------------+--------+
```

6. Cмотрим информацию о имени и id сети; подсетей своего каталога с помощью команд yc vpc network list; yc vpc subnet list:

```bash
➜  Deron-D_infra git:(terraform-1) ✗ yc vpc network list
+----------------------+--------+
|          ID          |  NAME  |
+----------------------+--------+
| enpf84mr5ho6p6299th2 | my-net |
+----------------------+--------+

➜  Deron-D_infra git:(terraform-1) ✗ yc vpc subnet list
+----------------------+----------------------+----------------------+----------------+---------------+-----------------+
|          ID          |         NAME         |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |      RANGE      |
+----------------------+----------------------+----------------------+----------------+---------------+-----------------+
| b0c5fukgbccn94q1o2ja | my-net-ru-central1-c | enpf84mr5ho6p6299th2 |                | ru-central1-c | [10.130.0.0/24] |
| e2l35j160p54h8m8k41u | my-net-ru-central1-b | enpf84mr5ho6p6299th2 |                | ru-central1-b | [10.129.0.0/24] |
| e9bogf7vjavut5hrqrjl | my-net-ru-central1-a | enpf84mr5ho6p6299th2 |                | ru-central1-a | [10.128.0.0/24] |
+----------------------+----------------------+----------------------+----------------+---------------+-----------------+
```

7. Правим main.tf до состояния:

```terraform
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
```

8. Для того чтобы загрузить провайдер и начать его использовать выполняем следующую команду в
директории terraform:

```bash
terraform init
```

9. Планируем изменения:

```bash
➜  Deron-D_infra git:(terraform-1) ✗ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.app will be created
  + resource "yandex_compute_instance" "app" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "reddit-app"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + description = (known after apply)
              + image_id    = "fd8190armqc6lvi7l8bq"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = true
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = "enpf84mr5ho6p6299th2"
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

10. Создаем VM согласно описанию в манифесте main.tf:

```bash
➜  terraform git:(terraform-1) terraform apply -auto-approve
yandex_compute_instance.app: Creating...
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.app: Still creating... [30s elapsed]
yandex_compute_instance.app: Still creating... [40s elapsed]
yandex_compute_instance.app: Creation complete after 44s [id=fhmlc5re13c4l7j3pu5k]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

11. Смотрим внешний IP адрес созданного инстанса,
```bash
Deron-D_infra git:(terraform-1) ✗ terraform show | grep nat_ip_address
        nat_ip_address = "62.84.119.129"
```

12. Пробуем подключиться по SSH:
```bash
➜  Deron-D_infra git:(terraform-1) ✗ ssh ubuntu@62.84.119.129
The authenticity of host '62.84.119.129 (62.84.119.129)' can't be established.
ECDSA key fingerprint is SHA256:EYLFosa66FgTBPXzrhuv1dMhZxZzDoISvtx1hWiGVks.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '62.84.119.129' (ECDSA) to the list of known hosts.
ubuntu@62.84.119.129's password:

```

13. Нужно определить SSH публичный ключ пользователя ubuntu в метаданных нашего инстанса добавив в main.tf:
```terraform
metadata = {
ssh-keys = "ubuntu:${file("~/.ssh/appuser.pub")}"
}
```

14. Проверяем:

```bash
ssh ubuntu@62.84.119.129 -i ~/.ssh/appuser -o StrictHostKeyChecking=no
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:oSlrlVZN4mfxcXIho/FezIPb3xXjMKJwX5E+85+wawI.
Please contact your system administrator.
Add correct host key in /home/dpp/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/dpp/.ssh/known_hosts:11
Password authentication is disabled to avoid man-in-the-middle attacks.
Keyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-142-generic x86_64)
* Documentation:  https://help.ubuntu.com
* Management:     https://landscape.canonical.com
* Support:        https://ubuntu.com/advantage
```

15. Создадим файл outputs.tf для управления выходными переменными с содержимым:
```terraform
output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}
```

16. Проверяем работоспособность outputs.tf:

```bash
➜  Deron-D_infra git:(terraform-1) ✗ terraform refresh
yandex_compute_instance.app: Refreshing state... [id=fhm08gs8ma628cvngi7m]

Outputs:

external_ip_address_app = 62.84.115.191
```

17. Добавляем provisioners в main.tf:

```terraform
provisioner "file" {
  source = "files/puma.service"
  destination = "/tmp/puma.service"
}

provisioner "remote-exec" {
script = "files/deploy.sh"
}
```

18. Создадим файл юнита для провижионинга [puma.service](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-1/terraform/files/puma.service)

19. Добавляем секцию для определения паметров подключения привиженеров:

```hcl
connection {
  type = "ssh"
  host = yandex_compute_instance.app.network_interface.0.nat_ip_address
  user = "ubuntu"
  agent = false
  # путь до приватного ключа
  private_key = file("~/.ssh/appuser")
  }
```

20. Проверяем работу провижинеров. Говорим terraform'y пересоздать ресурс VM при следующем
применении изменений:

```bash
➜  terraform git:(terraform-1) ✗ terraform taint yandex_compute_instance.app
Resource instance yandex_compute_instance.app has been marked as tainted.
```

21. Планируем и применяем изменения:

```bash
terraform plan
➜  Deron-D_infra git:(terraform-1) ✗ terraform taint yandex_compute_instance.app
Resource instance yandex_compute_instance.app has been marked as tainted.
➜  Deron-D_infra git:(terraform-1) ✗ terraform apply --auto-approve
yandex_compute_instance.app: Refreshing state... [id=fhm8qlanghmene5ijacb]
```


22. Проверяем результат изменений и работу приложения:

```bash
yandex_compute_instance.app: Creation complete after 2m33s [id=fhmsrsarg9tokee2dl8l]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

external_ip_address_app = 51.250.12.59
terraform apply --auto-approve
```

23. Параметризируем конфигурационные файлы с помощью входных переменных:
- Создадим для этих целей еще один конфигурационный файл [variables.tf](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-1/terraform/variables.tf)

- Определим соответствующие параметры ресурсов main.tf через переменные:

```terraform
provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  zone = var.zone
}
```

```terraform
boot_disk {
  initialize_params {
    # Указать id образа созданного в предыдущем домашем задании
    image_id = var.image_id
  }
}

network_interface {
  # Указан id подсети default-ru-central1-a
  subnet_id = var.subnet_id
  nat       = true
}

metadata = {
ssh-keys = "ubuntu:${file(var.public_key_path)}"
}
```

24. Определим переменные, используя специальный файл [terraform.tfvars](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-1/terraform/terraform.tfvars.example)

25. Форматирование и финальная проверка:

```bash
terraform fmt
terraform destroy
terraform plan
terraform apply --auto-approve
```

## **Проверка сервиса по адресу: [http://62.84.127.170:9292/](http://62.84.127.170:9292/)**
---

### Создание HTTP балансировщика `**`
1. Создадим файл lb.tf со следующим содержимым:

```terraform
resource "yandex_lb_target_group" "reddit_lb_target_group" {
  name      = "reddit-app-lb-group"
  region_id = var.region_id

  target {
    subnet_id = var.subnet_id
    address   = yandex_compute_instance.app.network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "load_balancer" {
  name = "reddit-app-lb"

  listener {
    name = "reddit-app-listener"
    port = 80
    target_port = 9292
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.reddit_lb_target_group.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 9292
        path = "/"
      }
    }
  }
}
```

2. Добавляем в outputs.tf переменные адреса балансировщика и проверяем работоспособность решения:

```terraform
output "loadbalancer_ip_address" {
  value = yandex_lb_network_load_balancer.load_balancer.listener.*.external_address_spec[0].*.address
}
```

3. Добавляем в код еще один terraform ресурс для нового инстанса приложения (reddit-app2):
- main.tf

```terraform
resource "yandex_compute_instance" "app2" {
  name = "reddit-app2"
  resources {
    cores  = 2
    memory = 2
  }
...
  connection {
    type  = "ssh"
    host  = yandex_compute_instance.app2.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file("~/.ssh/appuser")
  }
```

- lb.tf
```terraform
target {
  address = yandex_compute_instance.app2.network_interface.0.ip_address
  subnet_id = var.subnet_id
}
```

- outputs.tf

```terraform
output "external_ip_address_app2" {
  value = yandex_compute_instance.app2.network_interface.0.nat_ip_address
}
```

## **Проблемы в данной конфигурации:**
- Избыточный код
- На инстансах нет единого бэкэнда в части БД (mongodb)

3. Подход с заданием количества инстансов через параметр ресурса count:
- Добавим  в variables.tf

```terraform
variable count_of_instances {
  description = "Count of instances"
  default     = 1
}
```
- В main.tf удалим код для reddit-app2 и добавим:

```terraform
resource "yandex_compute_instance" "app" {
  name  = "reddit-app-${count.index}"
  count = var.count_of_instances
  resources {
    cores  = 2
    memory = 2
  }
...
connection {
  type  = "ssh"
  host  = self.network_interface.0.nat_ip_address
  user  = "ubuntu"
  agent = false
  # путь до приватного ключа
  private_key = file("~/.ssh/appuser")
}
```

- В lb.tf внесем изменения для динамического определения target:

```terraform
dynamic "target" {
  for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
  content {
    subnet_id = var.subnet_id
    address   = target.value
  }
}
```

# **Полезное:**
- [Создать внутренний сетевой балансировщик](https://cloud.yandex.ru/docs/network-load-balancer/operations/internal-lb-create)
- [yandex_lb_network_load_balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/0.44.0/docs/resources/lb_network_load_balancer)
- [yandex_lb_target_group](https://registry.terraform.io/providers/yandex-cloud/yandex/0.44.0/docs/resources/lb_target_group)
- [dynamic Blocks](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)
- [HashiCorp Terraform 0.12 Preview: For and For-Each](https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each)

</details>



# **Лекция №9: Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform**
> _terraform-2_
<details>
 <summary>Работа с Terraform в команде</summary>

## **Задание:**
Создание Terraform модулей для управления компонентами инфраструктуры.

Цель:
В данном дз студент продолжит работать с Terraform. Опишет и произведет настройку нескольких окружений при помощи Terraform. Настроит remote backend.
В данном задании тренируются навыки: работы с Terraform, использования внешних хранилищ состояния инфраструктуры.

Описание и настройка инфраструктуры нескольких окружений. Работа с Terraform remote backend.

Критерии оценки:
0 б. - задание не выполнено
1 б. - задание выполнено
2 б. - выполнены все дополнительные задания

---

## **Выполнено:**
1. Создаем новую ветку в инфраструктурном репозитории и подчищаем результаты заданий со ⭐:

```bash
git checkout -b terraform-2
git mv terraform/lb.tf terraform/files/
```

2. Зададим IP для инстанса с приложением в виде внешнего ресурса, добавив в `main.tf`:

```hcl
resource "yandex_vpc_network" "app-network" {
  name = "reddit-app-network"
}
resource "yandex_vpc_subnet" "app-subnet" {
  name           = "reddit-app-subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
```

- также добавим в 'main.tf' ссылку на внешний ресурс:

```hcl
network_interface {
  subnet_id = yandex_vpc_subnet.app-subnet.id
  nat = true
}
```

3. Применим изменения
```bash
➜  terraform git:(terraform-2) ✗ terraform destroy
➜  terraform git:(terraform-2) ✗ terraform apply --auto-approve
yandex_vpc_network.app-network: Creating...
yandex_vpc_network.app-network: Creation complete after 1s [id=enpg13juslvurvb9ubr9]
yandex_vpc_subnet.app-subnet: Creating...
yandex_vpc_subnet.app-subnet: Creation complete after 1s [id=e9be27mnk49np70ijone]
yandex_compute_instance.app[0]: Creating...
```

Видим, что ресурс VM начал создаваться только после
завершения создания yandex_vpc_subnet в результате неявной зависимости этих ресурсов.

4. Создание раздельных образов для инстансов app и db с помощью Packer:

В директории packer, где содержатся ваши шаблоны для билда VM, создадим два новых шаблона [db.json](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-2/packer/db.json) и [app.json](https://github.com/Otus-DevOps-2021-11/Deron-D_infra/blob/terraform-2/packer/app.json).

В качестве базового шаблона используем уже имеющийся шаблон ubuntu16.json, корректирую только соответствующие секции с наименованиями образов и секциями провизионеров.
~~~bash
cd packer
packer build -var-file=./variables.json ./db.json
packer build -var-file=./variables.json ./app.json
~~~


5. Создадим две VM

Разобьем конфиг `main.tf` на несколько конфигов
Создадим файл `app.tf`, куда вынесем конфигурацию для VM с приложением:
~~~hcl
resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
~~~

И создадим файл `db.tf`, куда вынесем конфигурацию для VM с приложением:
~~~hcl
resource "yandex_compute_instance" "db" {
  name = "reddit-db"
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet.id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
~~~

Не забудем объявить соответствующие переменные для образов приложения и базы данных в `variables.tf`:

~~~hcl
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-db-base"
}
~~~

Создадим файл `vpc.tf`, в который вынесем конфигурацию сети и подсети, которое применимо для всех инстансов нашей сети.
~~~hcl
resource "yandex_vpc_network" "app-network" {
  name = "app-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "app-subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
~~~

В итоге, в файле `main.tf` должно остаться только определение провайдера:
~~~hcl
provider "yandex" {
  version                  = 0.35
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
~~~

Не забудем добавить nat адреса инстансов в `outputs.tf` переменные:
~~~hcl
output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}
output "external_ip_address_db" {
  value = yandex_compute_instance.db.network_interface.0.nat_ip_address
}
~~~

```bash
t➜  terraform git:(terraform-2) ✗ terraform apply --auto-approve
yandex_vpc_network.app-network: Refreshing state... [id=enpolo5jf02oabepguhn]
yandex_vpc_subnet.app-subnet: Refreshing state... [id=e9bg6q0755m37i0q6994]
yandex_compute_instance.app: Creating...
yandex_compute_instance.db: Creating...
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.db: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.db: Still creating... [20s elapsed]
yandex_compute_instance.db: Still creating... [30s elapsed]
yandex_compute_instance.app: Still creating... [30s elapsed]
yandex_compute_instance.db: Still creating... [40s elapsed]
yandex_compute_instance.app: Still creating... [40s elapsed]
yandex_compute_instance.db: Creation complete after 45s [id=fhmb2p80u23caniggojr]
yandex_compute_instance.app: Still creating... [50s elapsed]
yandex_compute_instance.app: Still creating... [1m0s elapsed]
yandex_compute_instance.app: Creation complete after 1m3s [id=fhm3v1imfe15tibmvott]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = [
  "51.250.9.58",
]
external_ip_address_db = 62.84.115.41
```
Проверим доступность по SSH:
~~~bash
➜  terraform git:(terraform-2) ✗ ssh ubuntu@51.250.9.58 -i ~/.ssh/appuser
➜  terraform git:(terraform-2) ✗ ssh ubuntu@62.84.115.41 -i ~/.ssh/appuser
~~~

Удалим созданные ресурсы, используя terraform destroy
~~~bash
terraform destroy --auto-approve
~~~

6. Создание модулей

Внутри директории terraform создадим директорию modules, в которой мы будем определять модули.

Внутри директории modules создадим директорию db со следующими файлами:
`main.tf`
~~~hcl
resource "yandex_compute_instance" "db" {
  name = "reddit-db"
  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = var.db_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  scheduling_policy {
    preemptible = true
  }
}
~~~

`variables.tf`
~~~hcl
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable private_key_path {
  description = "path to private key"
}
~~~

`outputs.tf`
~~~hcl
output "external_ip_address_db" {
  value = yandex_compute_instance.db.network_interface.0.nat_ip_address
}
~~~

Создадим по аналогии для модуля приложения директорию `modules\app` с содержимым
`main.tf`
~~~hcl
resource "yandex_compute_instance" "app" {
  name = "reddit-app"
  labels = {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  scheduling_policy {
    preemptible = true
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
~~~

`variables.tf`
~~~hcl
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable subnet_id {
  description = "Subnets for modules"
}
variable private_key_path {
  description = "path to private key"
}
~~~

`outputs.tf`
~~~hcl
output "external_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}
~~~


В файл `main.tf`, где у нас определен провайдер вставим секции вызова созданных нами модулей
~~~hcl
provider "yandex" {
  version                  = "0.35"
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "app_image" {
  name = var.app_disk_image
}

data "yandex_compute_image" "db_image" {
  name = var.db_disk_image
}

module "app" {
  source          = "./modules/app"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image  = "${data.yandex_compute_image.app_image.id}"
  subnet_id       = var.subnet_id
}
module "db" {
  source          = "./modules/db"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image   = "${data.yandex_compute_image.db_image.id}"
  subnet_id       = var.subnet_id
}
~~~

Из папки terraform удаляем уже ненужные файлы app.tf, db.tf, vpc.tf и изменяем `outputs.tf`:
~~~hcl
output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}
~~~

Для использования модулей нужно сначала их загрузить из указанного источника `source`:
~~~bash
➜  terraform git:(terraform-2) ✗ terraform get
- app in modules/app
- db in modules/db
~~~

Планируем изменения:
~~~bash
➜  terraform git:(terraform-2) ✗ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.yandex_compute_image.db_image: Refreshing state...
data.yandex_compute_image.app_image: Refreshing state...
...
Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
~~~

После применения конфигурации с помощью terraform apply в соответствии с нашей конфигурацией проверяем SSH доступ ко обоим инстансам
Проверим доступность по SSH:
~~~bash
➜  terraform git:(terraform-2) ✗ ssh ubuntu@62.84.118.253 -i ~/.ssh/appuser
➜  terraform git:(terraform-2) ✗ ssh ubuntu@62.84.126.94 -i ~/.ssh/appuser
~~~

7. Переиспользование модулей
В директории terrafrom создадим две директории: stage и prod. Скопируем  файлы main.tf, variables.tf, outputs.tf, terraform.tfvars из директории terraform в каждую из созданных директорий.

Поменяем пути к модулям в main.tf на ../modules/xxx вместо ./modules/xxx в папках stage и prod.

Проверим правильность настроек инфраструктуры каждого окружения:
~~~bash
cd stage
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve

cd ../prod
terraform init
terraform plan
terraform apply --auto-approve
terraform destroy --auto-approve
~~~

Отформатируем конфигурационные файлы, используя команду ` terraform fmt -recursive`


# **Полезное:**

</details>
