testapp_IP = 51.250.0.68
testapp_port = 9292

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
