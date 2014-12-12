require 'sinatra' 
require 'sinatra/reloader' if development?
require 'uri'
require 'data_mapper'
require 'pp'
require 'rubygems'
require 'sinatra/flash'
require './auth.rb'


# Configuracion en local
configure :development, :test do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 
                             "sqlite3://#{Dir.pwd}/my_walkers.db" )
end

# Configuracion para Heroku
configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
  #Comprobamos si el usuario no se ha registrado.
  if (!session[:user])
    erb :welcome
  else
    erb :index
  end
end

get '/signup' do
  if (!session[:user])
    erb :signup
  else
    redirect '/'
  end
end

post '/signup' do
  puts "inside post '/': #{params}"
  begin
    @objeto = Usuarios.first_or_create(:username => params[:usuario], :nombre => params[:nombre], :apellidos => params[:apellidos], :email => params[:email], :password => params[:pass1])
    session[:user] = params[:nombre]
  rescue Exception => e
    puts e.message
  end
  redirect '/'
end

get '/login' do
  if (!session[:user])
    erb :login
  else
    redirect '/'
  end 
end

post '/login' do
  begin
    @user = Usuarios.first(:username => params[:usuario], :password => params[:password])
    session[:user] = @user.nombre
  rescue Exception => e
    flash[:mensaje] = "El nombre de usuario y/o contraseña no son correctos."
    puts e.message
  end
  redirect './login'
end

get '/rutas' do
  if (!session[:user])
    redirect '/'
  else
    # Obtengo las rutas almacenadas
    @rutas = Rutas.all()
    #puts "Esta es la info de rutas"
    #puts @rutas[0].nombre
    erb :rutas
  end 
end

get '/ruta/:num' do
  #puts "Estamos en la ruta con id:"
  #puts params[:num]
  @ruta = Rutas.first(:id_rut => params[:num])
  erb :ruta
end

get '/ultimas' do
  if (!session[:user])
    redirect '/'
  else
    erb :ultimas
  end 
end

get '/logout' do
  session.clear
  redirect '/'
end