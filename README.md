SYTW-WalkERS
============
#Sistemas y Tecnologías Web - Proyecto WalkERS

**Autores: Eduardo Javier Acuña Ledesma | Sergio Díaz González | Rushil Lakhani Lakhani**

#### Coveralls:
[![Coverage Status](https://img.shields.io/coveralls/WalkERSProyect/SYTW-WalkERS.svg)](https://coveralls.io/r/WalkERSProyect/SYTW-WalkERS)

#### Travis: 
[![Build Status](https://travis-ci.org/WalkERSProyect/SYTW-WalkERS.svg?branch=master)](https://travis-ci.org/WalkERSProyect/SYTW-WalkERS)

###Descripción
Se ha implementado una red social sobre senderos:

* Los usuarios deberán registrarse y/o loguearse utilizando el login propio de la aplicación o utilizando Google o Facebook.
* Una vez identificado en el sistema, podremos:
	- Añadir nuevas rutas.
	- Indicar si te gusta esa ruta y postear.
	- Añadir amigos.

###Visualización en Heroku
También puedes ver la aplicación en Heroku pinchando [aquí](http://walkers.herokuapp.com//).

###Instalación

Lo primero que haremos será clonar el repositorio de github WalkERSProyect/SYTW-WalkERS de la siguiente forma: `git@github.com:WalkERSProyect/SYTW-WalkERS.git`.

Instalaremos las gemas necesarias: `bundle install`

Luego ejecutaremos en local, escribiendo `rake server`en la consola.

Por último, iremos a http://localhost:4567/ para poder usar la aplicación.

###Comprobación de los tests
Para comprobar los test con selenium ejecutar en terminal `rake selenium`.

Para comprobar test rspec `rake spec`.


# Referencias

- Apuntes de la asignatura Sistemas y Tecnologías Web de la ULL.


*Sistemas y Tecnologías Web - Eduardo Javier Acuña Ledesma | Sergio Díaz González | Rushil Lakhani Lakhani*
