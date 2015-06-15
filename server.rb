require 'sinatra'
require 'sinatra/flash'
require 'pry'
require 'httparty'

enable :sessions

def get_weather
  HTTParty.get("http://api.openweathermap.org/data/2.5/weather?zip=#{@weather},us")
end

def weather_icon
  get_weather['weather'][0]['icon']
end

def degrees_in_fahrenheit
  (9/5)*(get_weather['main']['temp'] - 273) + 32
end

get '/' do
  erb :index
end

post "/" do
  @weather = params[:zip_code]
  erb :index
end
