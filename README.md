# Alquiler Express

## Requerimientos

- Ruby 3.4.3

## Instalación

1. Clonar el repo localmente
2. En la carpeta del repo ejecutar: `gem install bundler`
3. Ejecutar `bundle install`

## Base de datos

La hay seeds en la carpeta `test/fixtures` para arrancar con algunas cosas en la base de datos.

Algunos comandos para manejar la base de datos:
- Crear: `rails db:create`
- Dropear: `rails db:drop`
- Cargar las tablas: `db:schema:load`
- Cargar los seeds: `db:fixtures:load`

Se pueden encadenar esos comandos. Por ejemplo, para borrar la base de datos y crearla de nuevo con los seeds:
```bash
rails db:drop db:create db:schema:load db:fixtures:load
```

## Servidor

Para levantar el servidor: `rails server` o `rails s`

Una vez levantado el servidor se puede acceder mediante un browser a la página en `localhost:3000`

Para abrir una consola del servidor: `rails console` o `rails c`
