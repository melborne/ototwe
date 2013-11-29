require 'em-http'
require 'em-http/middleware/oauth'
require 'yajl'

class TweetStream
  URL = 'https://stream.twitter.com/1/statuses/filter.json'

  attr_accessor :track_terms
  def initialize(track_terms:[], consumer_key: nil, consumer_secret: nil, access_token: nil, access_token_secret: nil)
    @track_terms = track_terms
    auth = {consumer_key: consumer_key, consumer_secret: consumer_secret,
            access_token: access_token, access_token_secret: access_token_secret}
    validate_auth(auth)
  end
  
  def ontweet(&blk)
    @callback = blk
  end

  def listen
    conn = EM::HttpRequest.new(URL, inactivity_timeout: 0)
    http = conn.post(track: @track_terms.join(','))
    
    parser.on_parse_complete = @callback
    http.stream { |data| parser << data if data }
  rescue => e
    abort "Connection failed: #{e}"
  end

  private
  def validate_auth(auth)
    unless auth.any? { |k,v| v.nil? }
      conn.use EM::Middleware::OAuth, auth
    else
      raise "Must pass oauth authenticate code"
    end
  end
  
  def parser
    @parser ||= Yajl::Parser.new(symbolize_key: true)
  end
end