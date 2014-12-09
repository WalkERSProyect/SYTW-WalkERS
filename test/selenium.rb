require 'capybara' # loading capybara
require 'capybara/dsl'
require 'rack/test'
require 'coveralls'
require 'rspec'

Coveralls.wear!

Capybara.default_driver = :selenium 

ENV['RACK_ENV'] = 'selenium'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :random
end


url = 'http://localhost:4567/'
url2 = 'http://localhost:4567/signup'

describe 'make API call to load path', :type => :feature do 
  it "should load the home page" do
    visit "#{url}"
    expect(page).to have_content("WalkERS")
  end
end


describe 'make API sign in whith a specific name' do
  it 'user register' do
    visit "#{url}/signup"
    fill_in 'user', :with => 'Sergio'
    fill_in 'nombre', :with => 'Sergio'
    click_on('Click para registrarte.')       
    expect(page).to have_content("Sergio")     
  end
end

describe 'make API login whith a specific name' do
  it 'user login' do
  	click_on('Salir')
    visit "#{url}/login"
    fill_in 'usuario', :with => 'Ser'
    click_on('Login')       
    expect(page).to have_content("Ser")     
  end
end
