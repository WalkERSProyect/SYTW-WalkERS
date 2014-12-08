require 'restclient'
require 'xmlsimple'

class Usuarios
  include DataMapper::Resource

  property :id,   		Serial
  property :username,   String
  property :password,   String
  property :nombre,     String
  property :apellidos,  String
  property :email,      String
  property :created_at, DateTime

end