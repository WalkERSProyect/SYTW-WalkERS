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

  has n, :visits

end


class Comentarios
  include DataMapper::Resource

  property :id,           Serial
  property :username,     String
  property :ruta_id,      Integer
  property :comentario,   String
  property :created_at,   DateTime


end


class Amigos
  include DataMapper::Resource

  property :id,           Serial 
  property :id_usuario,   Integer
  property :id_amigo,     Integer 
  property :nombre,       String  
  property :created_at,   DateTime
  property :updated_at,   DateTime

end

class Visit
  include DataMapper::Resource

  property  :id,          Serial
  property  :created_at,  DateTime
  property  :ip,          IPAddress
  property  :country,     String
  
  belongs_to  :rutas


  before :create, :set_country

  def set_country
    xml = RestClient.get "http://ip-api.com/xml/#{self.ip}"  
    pais = XmlSimple.xml_in(xml.to_s, { 'ForceArray' => false })['country'].to_s
    p "Este es el pais: "
    p pais
    if (pais == "") 
      pais = "No encontrada"
    end
    self.country = pais
    self.save
  end

  def self.fecha_por_dias(id)
    repository(:default).adapter.select("SELECT date(created_at) AS date, count(*) AS count FROM visits WHERE rutas_id = '#{id}' GROUP BY date(created_at)")
  end

  def self.pais_contador(id)
    repository(:default).adapter.select("SELECT country, count(*) AS count FROM visits WHERE rutas_id = '#{id}' GROUP BY country")
  end  
                                   
end
