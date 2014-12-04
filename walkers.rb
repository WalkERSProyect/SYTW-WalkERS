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
  puts "inside get '/': #{params}"
  erb :signup
end

post '/' do
  #puts "Esto es /"
  puts "inside post '/': #{params}"

  @objeto = Usuarios.first_or_create(:username => params[:username], :nombre => params[:nombre], :apellidos => params[:apellidos], :email => params[:email], :password => params[:pass1])

  redirect '/'
end

get '/login' do
  erb :login
end

get '/logout' do
  session.clear
  redirect '/'
end