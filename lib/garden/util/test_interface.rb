# This is a test interface we include with various
# sintra component servers.  It supplies some simple
# endpoints for sanity testing to ensure that HTTP
# servers are up with basic functionality.
require 'sinatra/base'

# The TestInterface class, inheriting from Sinatra::Base.
# This allows us to use the Sinatra DSL within specific class
# files, but still maintain appropriate cohesion in server
# classes.
class TestInterface < Sinatra::Base

  # We have a basic index template defined in the data
  # segment of this class, at the end of this file.  In
  # order to use that template, we must enable inline
  # template processing.  This template is returned whenever
  # a request is made of the server root.
  enable :inline_templates

  # Initializing the class with the hostname and type of server.
  def initialize
    super
    @hostname = Socket.gethostname
    @type = ''
  end

  # Creates a 404 error.
  get '/test/error/404' do
    halt 404
  end

  # Creates a 500 error.
  get '/test/error/500' do
    halt 500
  end

  # Returns some simple information regarding the host, as wel
  # as a passed message.
  get '/test/*' do
    msg = params[:splat]
    content_type :txt
    "Howdy! This is the #{@type} node on #{@hostname}; msg = #{msg}."
  end

  # Returns information about the host and no message even if
  # one is submitted.
  get '/test' do
    content_type :txt
    "Howdy! This is the #{@type} node on #{@hostname}."
  end

  # Returns the HTML defined in the index template later in
  # this file.
  get '/' do
    erb :index
  end

end

__END__

@@index

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title><%= @hostname %> : Overlay Node</title>
  </head>
  <body>
    <p>
    <b>This is the <%= @type %> node on <%= @hostname %>.</b>
    </p>
  </body>
</html>