require 'restclient'
require 'xmlsimple'

class Usuarios
  include DataMapper::Resource

  property :id,   		  Serial
  property :username,   String
  property :password,   String
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
  property :puntuacion, 	Decimal
  property :votos, 			  Integer
  property :imagen,       String
  property :created_at, 	DateTime

end

class Amigos
  include DataMapper::Resource

  property :id,           Serial 
  property :id_usuario,   Integer
  property :id_amigo,     Integer   
  property :created_at,   DateTime
  property :updated_at,   DateTime

end
