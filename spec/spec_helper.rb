require 'rspec'
require 'capybara/rspec'

require_relative '../server.rb'

set :environment, :test

Omniauth.config.test_mode = true
#add database cleaner

Capybara.app = Sinatra::Application

def sign_in_as(user)
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
    :provider => 'github',
    :uid => user.uid
  })
  click_link 'Sign In'
end
