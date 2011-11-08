require 'sinatra'
require './app/box_auth'

enable :sessions
set :box_api_key, ENV['BOX_API_KEY']

Sinatra.register Sinatra::BoxAuth

get "/" do
  redirect "/login" unless session[:box_account]

  "Hello #{ session[:box_account].login }"
end
