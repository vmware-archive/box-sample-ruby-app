# This module is a simple Box authentication library that will work in any application.

require 'box-api'

module Box
  module SimpleAuth
    # Authenticates the user using the given API key and session information.
    # The session information is used to keep the user logged in.
    def box_login(box_api_key, session)
      # make a new Account object using the API key
      account = Box::Account.new(box_api_key)

      # use a saved ticket or request a new one
      ticket = session[:box_ticket] || account.ticket
      token = session[:box_token]

      # try to authorize the account using the ticket and/or token
      authed = account.authorize(:ticket => ticket, :auth_token => token) do |auth_url|
        # this block is called if the authorization failed

        # save the ticket we used for later
        session[:box_ticket] = ticket

        # yield with the url the user must visit to authenticate
        yield auth_url if block_given?
      end

      if authed
        # authentication was successful, save the token for later
        session[:box_token] = account.auth_token

        # return the account
        return account
      end
    end

    # Removes session information so the account is forgotten.

    # Note: This doesn't actually log the user out, and the auth_token is still valid.
    #       Be sure to call 'account.logout' if you want proper logout behavior.
    def box_logout(session)
      session.delete(:box_token)
      session.delete(:box_ticket)
    end
  end
end
