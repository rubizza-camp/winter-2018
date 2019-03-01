## Description

App for the implementation of [Homework 2](https://github.com/rubizza-survival-camp/winter-2018#homework-2).

## Dependencies

PostgreSQL, Webpacker. For other stuff use `bundle install` and `yarn install --force`.

## Pre-configuration

* You need to put your credentials into `config/application.yml` for getting the admin panel work, example:

```
ADMIN_NAME: 'admin'
ADMIN_PASSWORD: 'admin'
```

* After db migration use `rails db:seed` for getting predefined dishes and users list. After that for testing you may use accounts `1@te.st` and `2@te.st`, both has password `1`.
