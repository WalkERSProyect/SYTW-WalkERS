require 'bundler/setup'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'
require 'pry'
require 'erubis'


#**** AUTENTICACION ****
set :erb, :escape_html => true

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
  provider :facebook, config['identifier_f'], config['secret_f']
end


get '/auth/:name/callback' do
  
  session[:auth] = @auth = request.env['omniauth.auth']
  
  #session[:name] = @auth['info'].name
  nombre_completo = @auth['info'].name.split

  session[:name] = nombre_completo[0]
  session[:surname] = nombre_completo[1,nombre_completo.length].join(" ")
  session[:image] = @auth['info'].image
  #session[:user] = nombre_completo[0]
  #session[:apellidos] = nombre_completo[1,nombre_completo.length].join(" ")
  #session[:imagen] = @auth['info'].image
  session[:url] = @auth['info'].urls.values[0]
  session[:email] = @auth['info'].email
  session[:logs] = ''

  #puts ":Name= "+session[:name]
  #puts ":Auth= "+session[:auth]
  #puts ":image= "+session[:image]
  #puts ":url= "+session[:url]
  #puts ":email"+session[:email]
  #puts ":logs"+session[:logs]
  #flash[:notice] =
    #{}%Q{<div class="chuchu">Autenticado como #{@a...uth['info'].name}.</div>}
   #{}%Q{<div class="chuchu">Autenticado como #{@a...uth['info'].name}.</div>}

  # Añadir a la base de datos directamente, siempre y cuando no exista
  #if !User.first(:username => session[:email])
  #  u = User.create(:username => session[:email])
  #  u.save
  #end

  redirect '/getUser'
end

get '/auth/failure' do
  flash[:mensajeRojo] = "Fallo en la autenticación. Inténtelo de nuevo más tarde."
   # %Q{<div class="error-auth">Error: #{params[:message]}.</div>}
  #session[:logs] = "Error!!!"
  redirect '/'
end