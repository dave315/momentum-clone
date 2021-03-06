require 'sinatra'
require 'sinatra/flash'
require 'pry'
require 'httparty'
require 'Dotenv'
require 'sinatra/activerecord'
require 'omniauth-github'
require 'sinatra/reloader'

require_relative 'config/application'
require_relative './models/user'

###############NOTES######################
#*https://chrome.google.com/webstore/detail/new-tab-redirect/icpgjfneehieebagbmdbhnlpiopdcmna# <-- for custom new tab
##########################################

Dotenv.load

Dir['momentum-clone/**/*.rb'].each { |file| require_relative file }

enable :sessions

def greeting
  if Time.now.hour < 12
    "Good Morning, #{current_user.username}"
  elsif Time.now.hour.between?(12, 9)
    "Good Evening, #{current_user.username}"
  else
    "Have a good night, #{current_user.username}"
  end
end

########### OMNI AUTH HELPERS #############
helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end

end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

def is_member?(meetup_id, user_id)
  if signed_in?
    !Membership.where(["user_id = ? and meetup_id = ?", user_id, meetup_id]).empty?
  end
end

############ WEATHER API METHODS ###########
def get_weather
  HTTParty.get("http://api.openweathermap.org/data/2.5/weather?zip=#{current_user.zip_code},us")
end

def weather_icon
  get_weather['weather'][0]['icon']
end

def degrees_in_fahrenheit
  kelvin_temp = get_weather['main']['temp']
  (kelvin_temp * (1.8)) - 459.67
end


############## MY HTTP REQUESTS ################
get '/' do
  redirect "sign-in" unless current_user.present?
  erb :index
end

#post to /zip-codes & validate
post '/' do
  # if params[:zip_code].blank?
  #   current_user.errors.add(:zip_code, "can't be blank")
  # end
  current_user.zip_code = params[:zip_code]
  current_user.save

  #redirect and flash notification about success
  erb :index
end

get "/sign-in" do
  erb :sign_in
end

############ OMNI AUTH REQUESTS ###############
get '/auth/github/callback' do
  auth = env['omniauth.auth']
  user = User.find_or_create_from_omniauth(auth)

  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"
  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
