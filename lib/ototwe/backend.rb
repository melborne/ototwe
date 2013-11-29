require 'faye/websocket'
require 'tweet_stream'

module OtoTwe
  class Backend
    KEEPALIVE_TIME = 15
    def initialize(app, track_terms:[], auth:{})
      @app = app
      @clients = []
      @tweet_streamer = TweetStream.new(auth)
      @tweet_streamer.track_terms = track_terms
    end
    
    def call(env)
      if Faye::EventSource.eventsource?(env)
        es = Faye::EventSource.new(env, pin: KEEPALIVE_TIME)
        p [:open, es.url, es.last_event_id]
        EM.schedule do
          @tweet_streamer.ontweet do |tweet|
            begin
              return nil unless tweet && tweet[:user]
              user = tweet[:user][:screen_name]
              text = tweet[:text]
              es.send(parse_sound text)
              puts "\e[32m#{user}\e[0m: #{text}"
            rescue
              nil
            end
          end
          @tweet_streamer.listen
          
          trap("INT") do
            puts 'Caught sigint'
            EM.stop
          end
        end
        es.rack_response
      else
        @app.call(env)
      end
    end
  end
end