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


def get_remote_ip(env)
  puts "request.url = #{request.url}"
  puts "request.ip = #{request.ip}"
  if addr = env['HTTP_X_FORWARDED_FOR']
    puts "env['HTTP_X_FORWARDED_FOR'] = #{addr}"
    addr.split(',').first.strip
  else
    puts "env['REMOTE_ADDR'] = #{env['REMOTE_ADDR']}"
    env['REMOTE_ADDR']
  end
end

get '/' do
  #Comprobamos si el usuario no se ha registrado.
  if (!session[:user])
    haml :welcome, :layout => false 
  else
    # Obtenemos las últimas rutas añadidas
    @ultimas_rutas = Rutas.all(:limit => 4, :order => [ :created_at.desc ])
    # Obtenemos las rutas más populares
    @populares_rutas = Rutas.all(:limit => 4, :order => [:puntuacion.desc])
    haml :index
  end
end

get '/signup' do
  if (!session[:user])
    erb :signup
  else
    redirect '/, :order => [:puntuacion.desc]'
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
      session[:username] = session[:usuario]
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
      session[:username] = params[:usuario]
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
      session[:username] = params[:usuario]
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
      session[:username] = @user.username      
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

get '/addruta' do
  if (!session[:user])
    redirect '/'
  else
    erb :addruta
  end
end  

post '/addruta' do
  if (!session[:user])
    redirect '/'
  else
    #puts "Estoy aqui en el post de add ruta"
    #puts "Nombraco " + params[:nombre]
    #puts "Difi " + params[:dificultad]
    #puts "Info " + params[:descripcion]
    @ruta=Rutas.first_or_create(:nombre => params[:nombre] ,:dificultad => params[:dificultad], :informacion => params[:descripcion])
    #@ruta.save
    
    redirect '/rutas'
  end
end

get '/ruta/:num' do
  #puts "Estamos en la ruta con id:"
  #puts params[:num]

  #puts "Este debiera ser el parámetro= " + params[:num]
  @ruta = Rutas.first(:id_rut => params[:num])
  @comentario = Comentarios.all(:ruta_id => params[:num])
  visitas = Visit.new(:ip => get_remote_ip(env), :rutas_id_rut => params[:num])
  visitas.save
  contador = Visit.all(:rutas_id_rut => params[:num])
  puts "Esta pagina tiene tantas visitas"
  puts contador.count
  haml :ruta
end

post'/ruta/:num' do
  #puts "eys. en el post"
  puts "Estamos en la ruta con id:"
  puts params[:num]
  @comenta = Comentarios.first_or_create(:username => session[:username], :ruta_id => params[:num], :comentario => params[:mensaje])
  redirect "/ruta/#{params[:num]}"
end

get '/ultimas' do
  if (!session[:user])
    redirect '/'
  else
    erb :ultimas
  end 
end

get '/estadisticas/:id' do
  
  
end

get '/amigos' do
   if (!session[:user])
    redirect '/'
  else
   @mostrar = false
  @amigo = Amigos.all() # SELECT * FROM AMIGOS
    for i in 0...Amigos.count()
      if ((session[:id] == @amigo[i].id_usuario) && (@amigo[i].nombre))
          @mostrar = true
     end 
    end
    if (@mostrar == true)
      haml :amigos
    else  
      flash[:mensaje] = "El usuario no tiene amigos"
      redirect '/buscaramigos'
    end  
  end   
end


get '/buscaramigos' do
  if (!session[:user])
    redirect '/'
  else
     haml :buscaramigos
  end  
end

post '/buscaramigos' do 
  @usuario = Usuarios.first(:username => params[:usuario]) # SELECT * FROM USUARIOS WHERE USERNAME = "params usuario"
  if (!@usuario)
    flash[:mensaje] = "No existe ningun usuario con ese nombre"
    redirect '/buscaramigos'
  elsif (@usuario.nombre == session[:user])
    flash[:mensaje] = "El usuario que esta buscando es usted mismo"
    redirect '/buscaramigos'   
  else
    haml :buscaramigos
  end
end
 
post '/añadiramigo' do
  @usuario = Usuarios.first(:username => params[:usuario]) # Usuario introducido por teclado
  @amigos = Amigos.all()
  @amigo = Amigos.first(:nombre => params[:usuario]) # SELECT * FROM AMIGOS WHERE NOMBRE = "params usuario"
  for i in 0...Amigos.count()
    if ((@amigos[i].nombre == params[:usuario]) && (@amigos[i].id_usuario == session[:id]))
      @encontrado = true
    end
  end    
  if ((@amigo) && (@encontrado == true)) # Si existe el amigo 
    flash[:mensaje] = "Ya tiene el amigo en su lista"
    redirect '/amigos'  
  else      
    @amigo = Amigos.first_or_create(:id_usuario => session[:id],:id_amigo => @usuario.id, :nombre => @usuario.nombre)
    flash[:mensaje] = "Amigo añadido con exito"
    redirect '/amigos'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end