require 'sinatra/base'
require 'haml'

module OtoTwe
  class App < Sinatra::Base
    get '/' do
      haml :index
    end
  end
end
