require 'sinatra' 
require 'sinatra/reloader' if development?
require 'uri'
require 'data_mapper'
require 'pp'
require 'rubygems'


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
  #puts "Esto es /"
  puts "inside post '/': #{params}"
  begin
    @objeto = Usuarios.first_or_create(:username => params[:user], :nombre => params[:nombre], :apellidos => params[:apellidos], :email => params[:email], :password => params[:pass1])
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
    #@user = Usuarios.first(:username => params[:usuario], :password => params[:password])
    #@user = Usuarios.all(:fields => [:nombre,:username,:email])
    @user = Usuarios.all(:conditions => {:username => params[:usuario]})
    puts "El contenido de la variable es:"
    puts @user.username
    session[:user]
    puts "El valor de la sesion es:"
    puts session[:user]
  rescue Exception => e
    puts e.message
  end
  redirect '/'
end

get '/logout' do
  session.clear
  redirect '/'
end