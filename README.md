# FileManager

## Описание проекта
Этот проект представляет собой мобильное приложение. Приложение включает в себя модули регистрации, авторизации, управления файлами.

## Основной функционал
- **Регистрация пользователей**

  Организовал процесс регистрации новых пользователей, реализовав `RegistrationViewController` и `RegistrationView`, который включает валидацию данных.

https://github.com/kodifyme/FileManager/assets/96241245/0622fec5-0593-4655-a99b-54241ee090c6

- **Авторизация и аутентификация**

  Разработал модуль авторизации, включающий контроллер `AuthorizationViewController` и `AuthorizationView` для входа в систему.

https://github.com/kodifyme/FileManager/assets/96241245/d5d91da2-43f8-4c09-b670-c8fb4025dd30

- **Управление файловой системой**

  Реализовал компоненты для управления файловой системой, включая просмотр, добавление и удаление файлов через `FileSystemViewController` и `FileSystemView`.
  Организована проверка состояния авторизации при запуске. В зависимости от состояния показывается экран `RegistrationViewController` или `FileSystemViewController`

https://github.com/kodifyme/FileManager/assets/96241245/9624f8fa-708f-4c43-a0f7-814834f7c09c
