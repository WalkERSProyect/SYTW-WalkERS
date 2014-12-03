require 'restclient'
require 'xmlsimple'

class Usuarios
  include DataMapper::Resource
  
  property :username,   Text
  property :password,   String
  property :nombre,     Text
  property :apellidos,  Text
  property :email,      Text
  property :created_at, DateTime

end