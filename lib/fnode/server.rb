
require 'sinatra'

module FNode
  class Server < Sinatra::Base
    get '/' do
      "OK"
    end
  end

end
