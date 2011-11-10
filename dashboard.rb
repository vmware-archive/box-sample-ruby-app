require 'box-api'
require 'sinatra'

require './lib/box_auth'

enable :sessions
set :box_api_key, ENV['BOX_API_KEY']

helpers do
  include Box::SimpleAuth

  def require_box_login
    box_login(session) do |auth_url|
      redirect auth_url
    end
  end

  def full(template, locals = {})
    erb(template, :locals => locals)
  end

  def partial(template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
end

get "/" do
  account = require_box_login
  root = account.root

  full :dashboard, :account => account, :root => root
end

get "/logout" do
  box_logout

  redirect "/"
end

get "/folder/:folder_id" do |folder_id|
  account = require_box_login
  folder = account.folder(folder_id)

  partial :folder, :folder => folder
end

get "/folder/add/:parent_id" do |parent_id|
  partial :add_folder, :parent_id => parent_id
end

post "/folder/add/:parent_id" do |parent_id|
  account = require_box_login
  parent = account.folder(parent_id)

  name = params[:name]
  folder = parent.create(name)

  partial :item, :item => folder
end

get "/file/:file_id" do |file_id|
  account = require_box_login
  file = account.file(file_id)

  partial :file, :file => file
end

post "/file/add/:parent_id" do |parent_id|
  account = require_box_login
  parent = account.folder(parent_id)
end
