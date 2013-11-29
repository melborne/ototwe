require 'em-http'
require 'em-http/middleware/oauth'
require 'yajl'

class TweetStream
  URL = 'https://stream.twitter.com/1/statuses/filter.json'

  attr_accessor :track_terms
  attr_reader :parser
  def initialize(track_terms:[], auth:{})
    @track_terms = track_terms
    @conn = EM::HttpRequest.new(URL, inactivity_timeout: 0)
    @conn.use EM::Middleware::OAuth, validate_auth(auth)
    @parser = Yajl::Parser.new(symbolize_keys: true)
  end
  
  def ontweet(&blk)
    @callback = blk
  end

  def listen
    http = @conn.post(query: {track: @track_terms.join(',')})
    parser.on_parse_complete = @callback
    http.stream { |data| parser << data if data }
  rescue => e
    abort "Connection failed: #{e}"
  end

  private
  def validate_auth(auth)
    keys = %i(consumer_key consumer_secret access_token access_token_secret)
    if (keys - auth.keys).empty? && auth.all? { |_,val| !val.nil? }
      auth
    else
      raise "Must pass oauth authenticate code"
    end
  end
end