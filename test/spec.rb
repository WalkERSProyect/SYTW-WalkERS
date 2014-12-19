require 'coveralls'
ENV['RACK_ENV'] = 'test'
require_relative '../walkers.rb'
require 'test/unit'
require 'rack/test'
require 'selenium-webdriver'
require 'rubygems'
require 'rspec'
require 'haml'

Coveralls.wear!

include Rack::Test::Methods
def app
  Sinatra::Application
end
describe "Rspec" do

	it "/ coincidendia de nombre 1" do
		get '/'
		last_response.body['Walkers']
	end	

	it '/ coincidencia de nombre 2' do
		get '/'
		last_response.body['Login']
	end

	it '/ coincidencia de nombre 3' do
		get '/'
		last_response.body['Comienza']
	end
    
    it 'Probar registro' do
		post '/signup',  :usuario => "sergio7", :nombre => "sergio" , :apellidos => "díaz", 
						 :email => "sergio@gmail.com", :pass1 => "1", :pass2=> "1", :imagen => "imagen.jpg"
		last_response.body['ÚLTIMAS RUTAS AÑADIDAS']
	end

	it 'Probar login' do
		post '/signup',  :usuario => "sergio7", :email => "sergio@gmail.com"
		last_response.body['ÚLTIMAS RUTAS AÑADIDAS']
	end

	it '/ coincidencia' do
		get '/configuracion'
		last_response.body['Actualiza']
	end

	it '/rutas' do
		get '/rutas'
		last_response.body['WalkERS']
	end


	it '/addruta' do
		get '/addruta'
		last_response.body['WalkERS']
	end


	it '/addruta' do
		get '/addruta'
		last_response.body['WalkERS']
	end

	it '/misrutas' do
		get '/mis rutas'
		last_response.body['WalkERS']
	end

	
#[:usuario], :[:nombre], [:apellidos], [:email], [:pass1],[:imagen]

   # it "sesión" do
      # get '/', {}, 'rack.session' => { :usuario => 'Eduardo' }
     #  expect(last_response).to be_ok
    #end


	#it '/ coincidencia de nombre 3' do
	#	get '/'
	#	last_response.body['y']
	#end

	#it '/chat coincidencia de nombre 3' do
	#	get '/'
	#	last_response.body['Usuarios conectados']
	#end

	#it 'post' do
	#	post '/', params = {:usuario => 'Sergio'}
	#	get '/chat'
	#	last_response.body['Diseñado']
	#end

	#it '/chat' do
	#	get '/chat'
	#	last_response.body['Bienvenido']
	#end

    

end
