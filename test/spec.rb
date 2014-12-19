require 'coveralls'
ENV['RACK_ENV'] = 'test'
require_relative '../walkers.rb'
require 'test/unit'
require 'rack/test'
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

	it 'post /addruta' do
		post '/addruta', :nombre => "Teide", :username => "Sergio", :dificultad => "Baja",
							:descripcion => "Muy bonito", :imagen => "imagen.jpg"

		last_response.body['Rutas']
	end


	it '/misrutas' do
		get '/rutas'
		last_response.body['WalkERS']
	end

    

end
