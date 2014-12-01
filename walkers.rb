require 'sinatra' 
require 'sinatra/reloader' if development?
#require 'uri'

enable :sessions
set :session_secret, '*&(^#234a)'

get '/' do
  #Comprobamos si el usuario no se ha registrado.
  if (!session[:user])
    erb :signup
  else
    erb :index
  end
end

get '/logout' do
  session.clear
  redirect '/'
end