require 'sinatra/base'
require 'box-api'

module Sinatra
  module BoxAuth
    enable :sessions

    get "/login" do
      # make a new Account object using the API key
      account = Box::Account.new(settings.box_api_key)

      # use a saved ticket or request a new one
      ticket = session[:box_ticket] || account.ticket
      token = session[:box_token]

      # update the variables if passed parameters (such as during a redirect)
      ticket = params[:ticket] if params[:ticket]
      token = params[:auth_token] if params[:auth_token]

      # try to authorize the account using the ticket and/or token (if given)
      account.authorize(:ticket => ticket, :auth_token => token) do |auth_url|
        # this block is called if the authorization failed

        # save the ticket we used for later
        session[:box_ticket] = ticket

        # redirect the user to the auth url
        redirect auth_url
      end

      # authentication was successful, save the details for later
      session[:box_token] = account.auth_token
      session[:box_account] = account

      redirect "/"
    end

    get "/logout" do
      session[:account].logout if session[:account]

      redirect "/"
    end
  end
end
