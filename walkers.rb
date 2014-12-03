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
  puts "Esto es / barroncia"
  puts "inside post '/': #{params}"
  nom = URI::parse(params[:nombre])
  #ap = URI::parse(params[:apellidos])
  #em = URI::parse(params[:email])
  #username = URI::parse(params[:user])
  
  #if (params[:pass1] == params[:pass2]) then
  #password = URI::parse(params[:pass1])
  #end
  puts "Este es el nombre #{nom}"
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    puts "hola"
    begin
      @objeto = Usuario.first_or_create(:username => params[:username], :nombre => params[:nombre])#, :apellidos => params[:apellidos], :email => params[:email], :password => params [:pass1])
      puts "Este es el nombre #{nom}"
      puts "Este es el objeto guardado #{objeto}"
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @objeto
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  redirect '/'
end

get '/login' do
  erb :login
end

get '/logout' do
  session.clear
  redirect '/'
end