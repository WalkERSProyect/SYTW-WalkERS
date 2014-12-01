ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'test/unit'
require_relative '../walkers.rb'
require_relative '../model.rb'

include Test::Unit::Assertions


include Rack::Test::Methods

def app
  Sinatra::Application
end


describe 'Tests de app.rb' do
  #before :all do

  #end   
         

  it "Comprobar que va a la index" do
    get '/'
    assert last_response.ok?
  end


  it "Comprobar texto correcto" do
    get '/'
    assert_match 'WalkERS', last_response.body
  end
    
    
end