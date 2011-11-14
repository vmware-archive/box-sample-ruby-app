Box Sample App
==============

Installation Guide
------------------

You need to register your Box application in order to get an API key. You can do that [here](http://www.box.net/developers/services).

While you're on that page, set your application's redirect url. This is the url the user is sent to after registering. It should be the address of your website, like "http://box-sample-app.herokuapp.com".


### Running on Heroku

Follow the normal [Heroku setup procedure](http://devcenter.heroku.com/articles/quickstart) to create your application. After pushing the code, all you need to do is run:

    heroku config:add BOX_API_KEY=<your api key>

That's it! Try `heroku open` and play around with your new site. It'll first prompt you to authenticate on Box, but once you've done that, you can navigate normally.


### Running locally

It's hard to test your code when you need to push it to Heroku each time. You can run the sample app easy, you just need a few things.

First off, you need to have a copy of Ruby 1.9. Ruby 1.8 might work, but is losing support and is not what you will be running on Heroku.

With Ruby installed, use Bundler to install all of the project dependencies.

    gem install bundler
    cd <project root>
    bundle

Lastly, you need to launch the Sinatra server. Prefix the command with your Box api key.

    cd <project root>
    BOX_API_KEY=<your api key> rackup

This will run the server on port 9292. Visit http://localhost:9292 to see your app in action.
