
require 'sinatra'

module FNode
  class Server < Sinatra::Base
    get '/' do
      "OK"
    end

    get '/run' do
    end

    get '/stop' do

    end

    
  end

end
