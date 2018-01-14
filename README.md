# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Comandos utilizados para cria a app
```bash
docker-compose run --rm app rails new . --force --api -d postgresql -T
```

### Comandos para desenvolviemnto

* Rodar os testes
```bash
docker-compose run --rm app bundle exec spring rspec
```

* Levantar a aplicação
```bash
docker-compose up
```

* Ajustando problema de permissão dos arquivos criados pelo docker (Vou resolver isso em breve)
```bash
sudo chown -R $USER:$USER .
```