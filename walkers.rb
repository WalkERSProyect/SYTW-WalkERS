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

#erb :site_layout, :layout => false do
#  erb :region_layout do
#    erb :page
#  end
#end

get '/' do
  #Comprobamos si el usuario no se ha registrado.
  if (!session[:user])
    haml :welcome, :layout => false
  else
    # Obtenemos las últimas rutas añadidas
    @ultimas_rutas = Rutas.all()
    haml :index
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
    @usuario = Usuarios.first(:username => params[:usuario])
    if (!@usuario)
      @objeto = Usuarios.first_or_create(:username => params[:usuario], :nombre => session[:name], :apellidos => session[:surname], :email => session[:email])
      session[:user] = session[:name]
      flash[:mensaje] = "¡Enhorabuena! Se ha registrado correctamente."
    else
      flash[:mensaje] = "El nombre de usuario ya existe. Por favor, elija otro."
      redirect '/getUser'
    end
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
    haml :rutas
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
  @mostrar = false
   if (!session[:user])
    redirect '/'
  else
    @amigos = Amigos.all() # SELECT * FROM AMIGOS
    for i in 0...Amigos.count()
      puts @amigos[i].id_usuario
      if (@amigos[i].id_usuario == session[:id])
        puts "hacia vista amigos"
        @mostrar = true
      end
    end
     if (@mostrar == true)
      erb :amigos  
     elsif (@mostrar == false) && (@amigos[session[:id]] == nil) 
        flash[:mensaje] = ":( El usuario no tiene amigos"
        redirect '/buscaramigos'  
      elsif (@mostrar == false) && (Amigos.count() != 0)
         flash[:mensaje] = "Los amigos no pertenecen a este usuario"  
        redirect '/buscaramigos'       
    end 
  end   
end

get '/buscaramigos' do
  if (!session[:user])
    redirect '/'
  else
     erb :buscaramigos
  end  
end

post '/buscaramigos' do
  @amigos = Amigos.all()
  @usuari = Usuarios.first(:username => params[:usuario]) # SELECT * FROM USUARIOS WHERE USERNAME = "params usuario"
  if (!@usuari)
    flash[:mensaje] = "No existe ningun usuario con ese nombre"
    redirect '/buscaramigos'
  elsif (@usuari.nombre == session[:user])
    flash[:mensaje] = "El usuario que esta buscando es usted mismo"
    redirect '/buscaramigos' 
  else   
    @usuario = Usuarios.first(:id => session[:id]) # SELECT * FROM AMIGOS WHERE ID = SESSION[ID]
    #if (@amigos[session[:id]].id_amigo != nil)
    puts @usuario.nombre # Usuario conectado actual
    puts @usuari.nombre # Usuario introducio por teclado
    puts "hola"
    if (@usuario.nombre == @usuari.nombre)
       flash[:mensaje] = "Ya tiene el amigo en su lista"
       redirect '/buscaramigos'  
    else      
      @amigo = Amigos.first_or_create(:id_usuario => session[:id],:id_amigo => @usuari.id, :nombre => @usuari.nombre)
      puts @amigo.nombre
      flash[:mensaje] = "Amigo añadido con exito"
      redirect '/buscaramigos'
    end
  end
end

get '/logout' do
  session.clear
  redirect '/'
end