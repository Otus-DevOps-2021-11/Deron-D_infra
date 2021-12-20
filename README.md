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
