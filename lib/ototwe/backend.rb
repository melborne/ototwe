require 'faye/websocket'
require 'ototwe/tweet_stream'

module OtoTwe
  class Backend
    KEEPALIVE_TIME = 15
    def initialize(app, track_terms:[], auth:{})
      @app = app
      @clients = []
      @tweet_streamer = TweetStream.new(track_terms: track_terms, auth: auth)
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
              tags = tweet[:entities][:hashtags]
              sounds = parse_sound_tag(tags)
              es.send(sounds)
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

    # "entities"=>{"hashtags"=>[{"text"=>"ototo", "indices"=>[3, 9]}, {"text"=>"C3", "indices"=>[10, 13]}],
    def parse_sound_tags(tags)
      sound = tags.map { |t| t['text'] }
                  .detect { |text| text.match /^[A-G][1-6]$/i } || ''
    end
  end
end
