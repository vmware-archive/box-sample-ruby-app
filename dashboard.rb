require 'sinatra/base'
require './lib/box_auth'

class BoxDashboard < Sinatra::Base
  include Box::SimpleAuth

  enable :sessions # required for Box::SimpleAuth
  set :box_api_key, ENV['BOX_API_KEY']

  get "/" do
    @account = require_box_login
    @root = @account.root

    erb :dashboard
  end

  get "/logout" do
    box_logout

    redirect "/"
  end
end
