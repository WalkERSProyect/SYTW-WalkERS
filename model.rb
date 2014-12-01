class Usuarios
  include DataMapper::Resource

  property :username, Text
  property :email, Text

end