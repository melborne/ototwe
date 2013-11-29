require 'sinatra/base'
require 'haml'

module OtoTwe
  class App < Siantra::Base
    get '/' do
      haml :index
    end
  end
end
