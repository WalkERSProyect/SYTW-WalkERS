require 'coveralls'
Coveralls.wear!
ENV['RACK_ENV'] = 'test'
require_relative '../walkers.rb'
require 'rack/test'
require 'rubygems'
require 'rspec'

include Test::Unit::Assertions


include Rack::Test::Methods

def app
  Sinatra::Application
end

describe 'Tests de walkers.rb' do
    it "Comprobar que va a la index" do
    get '/'
    assert last_response.ok?
  end

  it "Comprobar que va a la signup" do
    get '/signup'
    assert last_response.ok?
  end

  #it "Comprobar que entra a rutas" do
  #  get '/rutas'
  #  assert last_response.ok?
  #end

  it "Comprobar que va a la signup" do
    get '/login'
    assert last_response.ok?
  end

  it "Comprobar texto correcto" do
    get '/'
    assert_match 'WalkERS', last_response.body
  end



end

describe 'Tests de la tabla Usuario' do
  before :all do
    @username = 'alu4384'
    @nombre = 'Sergio'
    @apellidos = 'Rodríguez'
    @email = 'Diaz@gmail.es'
    #@objeto = Usuarios.first_or_create(:username => params[:username], :nombre => params[:nombre], :apellidos => params[:apellidos], :email => params[:email], :password => params[:pass1])
    @Objeto = Usuarios.first_or_create(:username => 'alu4384', :nombre =>'Sergio', :apellidos => 'Díaz', :email => 'Sergio@gmail.com')
  end

  it "Debe devolver que username alu4384 esta en la base de datos" do
    assert @username, @Objeto.username 
  end

  it "Debe devolver que el username es igual" do
    assert @nombre, @Objeto.nombre
  end    

  it "Debe devolver que no coincide los apellidos" do
    assert_not_same(@apellidos, @Objeto.apellidos)
  end

  it "Debe devolver que no coincide los email" do
    assert_not_same(@email, @Objeto.email)
  end   
end