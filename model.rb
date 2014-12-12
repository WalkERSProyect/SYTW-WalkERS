require 'restclient'
require 'xmlsimple'

class Usuarios
  include DataMapper::Resource

  property :id,   		  Serial
  property :username,   String
  property :password,   BCryptHash
  property :nombre,     String
  property :apellidos,  String
  property :email,      String
  property :created_at, DateTime

end


class Rutas
  include DataMapper::Resource

  property :id_rut,       Serial
  property :username,		  String
  property :nombre, 		  String
  property :informacion, 	String
  property :dificultad,   Integer
  property :puntuacion, 	Integer
  property :votos, 			  Integer
  property :imagen,       String
  property :created_at, 	DateTime

end
