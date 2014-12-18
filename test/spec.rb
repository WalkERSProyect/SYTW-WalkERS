require 'coveralls'
ENV['RACK_ENV'] = 'test'
require_relative '../walkers.rb'
require 'rack/test'
require 'rubygems'
require 'rspec'

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
    
    it '/' do
		post '/signup',  :usuario => "sergio7", :nombre => "sergio" , :apellidos => "díaz", 
						 :email => "sergio@gmail.com", :pass1 => "1", :pass2=> "1", :imagen => "imagen.jpg"
		last_response.body['ÚLTIMAS RUTAS AÑADIDAS']
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
