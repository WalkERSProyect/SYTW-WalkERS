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

get'/getUser' do
  begin
    puts "eyyyyyy"
    @email = Usuarios.first(:email => session[:email])
    #puts "Este es el email de la sesion "+session[:email]+" y de la variable @email "+@email.email
    #puts "Este debiera ser el nombre del que usa el email"+@email.nombre
    #puts ", y estas es la sesion del name"+session[:name]
    if (!@email)
      puts "en el if"
      erb :loginUser
    else
      puts "en el else"
      session[:user] = session[:name]
      redirect '/'
    end 
    rescue Exception => e
      flash[:mensaje] = "El nombre de usuario y/o contraseña no son correctos."
       puts e.message  
  end
end

post '/getUser' do
  begin
    @objeto = Usuarios.first_or_create(:username => params[:usuario], :nombre => session[:name], :email => session[:email])
    session[:user] = session[:name]
  rescue Exception => e
    puts e.message
  end
  redirect '/'
end

post '/signup' do
  puts "inside post '/': #{params}"
  begin
    @usuario = Usuarios.first(:username => params[:usuario])
    if (!@usuario)
      @objeto = Usuarios.first_or_create(:username => params[:usuario], :nombre => params[:nombre], :apellidos => params[:apellidos], :email => params[:email], :password => params[:pass1])
      session[:user] = params[:nombre]
      flash[:mensaje] = "¡Enhorabuena! Se ha registrado correctamente."
    else
      flash[:mensaje] = "El nombre de usuario ya existe. Por favor, elija otro."
      redirect '/signup'
    end
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
    @user = Usuarios.first(:username => params[:usuario])
    @user_hash = BCrypt::Password.new(@user.password)
    if (@user_hash == params[:password])
      session[:user] = @user.nombre
      session[:id] = @user.id
    else
      flash[:mensaje] = "El nombre de usuario y/o contraseña no son correctos."
      puts e.message
    end
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

get '/amigos' do
   if (!session[:user])
    redirect '/'
  else
    @amigos = Amigos.all() # SELECT * FROM AMIGOS
    puts @amigos
    erb :amigos
  end
end  

get '/buscaramigos' do
  if (!session[:user])
    redirect '/'
  else
     @usuario = Usuarios.all() #SELECT * FROM USUARIOS
     @contador = Usuarios.count
     @amigo  = Amigos.all()
     #@contador2 = Amigos.count
     #@añadido = false
     #puts "Contador es #{@contador2}"
     puts @usuario[0].username
     erb :buscaramigos
  end  
end

post '/buscaramigos' do
  @usuari = Usuarios.first(:username => params[:usuario]) # SELECT * FROM USUARIOS WHERE USERNAME = "params usuario"
  #@añadido = false
  if (!@usuari)
    flash[:mensaje] = "No existe ningun usuario con ese nombre"
    redirect '/'
  elsif (@usuari.nombre == session[:user])
    flash[:mensaje] = "El usuario que esta buscando es usted mismo"
    redirect '/' 
  else   
    #flash[:mensaje] = "El usuario que esta buscando se llama #{@usuari.username}"
    @amigo = Amigos.first_or_create(:id_usuario => session[:id])
    puts "Amigo"
    @amigo.id_amigo = nil # Solucion Temporal
    puts @amigo.id_amigo
    if (@amigo.id_amigo == nil)
      @amigo = Amigos.first_or_create(:id_usuario => session[:id],:id_amigo => @usuari.id, :nombre => @usuari.nombre)
      puts @amigo.id_amigo
      erb :añadiramigo
    else
      flash[:mensaje] = "Ya tiene el amigo en su lista"  
    end
  end
end

post '/añadiramigo' do
  if (!session[:user])
    redirect '/'
  else
    #@amigo  = Amigos.all()
    @opcion = params[:opcion]
    if (@opcion == '1') 
       flash[:mensaje] = "Amigo añadido con exito" 
       redirect '/'
    else
       flash[:mensaje] = "No desea añadir el amigo" 
       redirect '/'
    end         
  end 
end


get '/logout' do
  session.clear
  redirect '/'
end