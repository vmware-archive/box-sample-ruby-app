require 'box-api'

module Box
  module SimpleAuth
    def box_login
      # we have the account cached already
      return session[:box_account] if session[:box_account]

      # make a new Account object using the API key
      account = Box::Account.new(settings.box_api_key)

      # use a saved ticket or request a new one
      ticket = session[:box_ticket] || account.ticket
      token = session[:box_token]

      # update the variables if passed parameters (such as during a redirect)
      ticket = params[:ticket] if params[:ticket]
      token = params[:auth_token] if params[:auth_token]

      # try to authorize the account using the ticket and/or token (if given)
      authed = account.authorize(:ticket => ticket, :auth_token => token) do |auth_url|
        # this block is called if the authorization failed

        # save the ticket we used for later
        session[:box_ticket] = ticket

        # yield the url the user must visit
        yield auth_url if block_given?
      end

      if authed
        # authentication was successful, save the details for later
        session[:box_token] = account.auth_token
        session[:box_account] = account
      end
    end

    def require_box_login
      # login or redirect to the auth url
      box_login do |auth_url|
        redirect auth_url
      end
    end

    def box_logout
      if session[:account]
        session[:account].logout

        session.delete(:account)
        session.delete(:box_token)
        session.delete(:box_ticket)
      end
    end
  end
end
