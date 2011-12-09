# This sample app uses the Sinatra and Box-Api gems.
# Sinatra: http://www.sinatrarb.com/
# Box-Api: https://github.com/box/box-ruby-sdk

require 'box-api'
require 'sinatra'
require 'rack-flash'

# Helper class to make authorizing with Box easier.
require './lib/box_auth'

# This is where we set the API key given by Box.
# Get a key here: https://www.box.net/developers/services
set :box_api_key, ENV['BOX_API_KEY']

# Sessions are used to keep track of user logins.
enable :sessions
use Rack::Flash

# Helper methods are avaliable for access throughout the application.
helpers do
  # Include the authentication login in 'lib/box_auth'
  include Box::SimpleAuth

  # Requires the user to be logged into Box, or redirect them to the login page.
  def require_box_login
    box_login(settings.box_api_key, session) do |auth_url|
      redirect auth_url
    end
  end

  # Updates session data if a redirect url was used after authentication.
  # This method does not need to be used, but makes authentication faster.
  def update_box_login
    # update the variables if passed parameters (such as during a redirect)
    session[:box_ticket] ||= params[:ticket]
    session[:box_token] ||= params[:auth_token]
  end

  # Just renders a template with no special options
  def full(template, locals = {})
    erb(template, :locals => locals)
  end

  # Renders a template, but without the entire layout (good for AJAX calls).
  def partial(template, locals = {})
    erb(template, :layout => false, :locals => locals)
  end
end

# The root of your website. Accessible via http://<your-app>.cloudfoundry.com
get "/" do
  update_box_login            # updates login information if given
  account = require_box_login # make sure the user is authorized
  root = account.root         # get the root folder of the account

  # Render the dashboard template with these values
  full :dashboard, :account => account, :root => root
end

# Handles logout requests.
get "/logout" do
  box_logout(session)

  redirect "/" # redirect to the home page
end

# Gets a folder by id and returns its details.
get "/folder/:folder_id" do |folder_id|
  account = require_box_login        # make sure the user is authorized
  folder = account.folder(folder_id) # get the folder by id

  # Note: Getting a folder by ID is fastest, but it won't know about its parents.
  # If you need this information, use 'account.root.find(:id => folder_id)' instead.

  partial :folder, :folder => folder # render the information about this folder
end

# Displays the form for adding a new folder based on the parent_id.
get "/folder/add/:parent_id" do |parent_id|
  partial :add_folder, :parent_id => parent_id
end

# Creates a new folder with the given information.
post "/folder/add/:parent_id" do |parent_id|
  account = require_box_login        # make sure the user is authorized
  parent = account.folder(parent_id) # get the parent folder by id

  name = params[:name]         # get the desired folder name
  folder = parent.create(name) # create a new folder with this name

  partial :item, :item => folder # render the information about this folder
end

# Gets a file by id and returns its details.
get "/file/:file_id" do |file_id|
  account = require_box_login  # make sure the user is authorized
  file = account.file(file_id) # get the file by id

  # Note: Getting a file by ID is fastest, but it won't know about its parents.
  # If you need this information, use 'account.root.find(:id => file_id)' instead.

  partial :file, :file => file # render the information about this file
end

# Displays the form for adding a new file based on the parent_id.
get "/file/add/:parent_id" do |parent_id|
  partial :add_file, :parent_id => parent_id
end

# Creates a new folder with the given information.
post "/file/add/:parent_id" do |parent_id|
  account = require_box_login        # make sure the user is authorized

  tmpfile = params[:file][:tempfile] # get the path of the file
  name = params[:file][:filename]    # get the name of the file

  begin
    parent = account.folder(parent_id) # get the parent folder by id
    file = parent.upload(tmpfile) # upload the file by its path
    begin
      file.rename(name)             # rename the file to match its desired name
      flash[:notice] = "Added #{name}"
    rescue Box::Api::NameTaken => ex
      file.delete  #cleanup !
      flash[:error] = "File with name #{name} already exists"
    end
  rescue Exception => ex
    puts "Exception uploading file with name #{name} was #{ex.inspect}"
    flash[:error] = "Could not upload file"
  end
  redirect "/" # redirect to the home page
end
