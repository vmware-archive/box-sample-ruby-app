# This repository is no longer actively maintained by VMware, Inc.


Box Sample App
==============

Installation Guide
------------------

You need to register your Box application in order to get an API key. You can do that [here](http://www.box.net/developers/services).

While you're on that page, set your application's redirect url. This is the url the user is sent to after registering. It should be the address of your website, like "http://box-sample-app.cloudprovider.com".

### Running locally

You can run the sample app easy, you just need a few things.

First off, you need to have a copy of Ruby 1.9. Ruby 1.8 might work, but is losing support and is not what you will be running on your cloud provider.

With Ruby installed, use Bundler to install all of the project dependencies.

    gem install bundler
    cd <project root>
    bundle

Lastly, you need to launch the Sinatra server. Prefix the command with your Box api key.

    cd <project root>
    export BOX_API_KEY=<your api key>
    rackup

This will run the server on port 9292. Visit http://localhost:9292 to see your app in action.
