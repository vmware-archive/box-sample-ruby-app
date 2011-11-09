require 'sinatra/base'
require './lib/box_auth'

require 'box-api'

class BoxDashboard < Sinatra::Base
  include Box::SimpleAuth

  enable :sessions # required for Box::SimpleAuth
  set :box_api_key, ENV['BOX_API_KEY']

  helpers do
    def partial(template, locals = {})
      erb(template, :layout => false, :locals => locals)
    end
  end

  get "/" do
    @account = require_box_login
    @root = @account.root

    erb :dashboard
  end

  get "/logout" do
    box_logout

    redirect "/"
  end

  get "/navigate/:id" do |folder_id|
    @account = require_box_login
    folder = @account.folder(folder_id)

    partial :item_column, :root => folder
  end

  get "/preview/:id" do |file_id|
    @account = require_box_login
    file = @account.file(file_id)

    file.embed_code
  end
end
