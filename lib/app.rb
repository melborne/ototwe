require 'sinatra/base'
require 'haml'

module OtoTwe
  class App < Sinatra::Base
    configure :production do
      require 'newrelic_rpm'
    end

    get '/' do
      haml :index
    end
  end
end
