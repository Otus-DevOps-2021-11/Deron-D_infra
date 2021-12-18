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

## **Полезное:**
</details>
