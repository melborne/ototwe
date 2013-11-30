require 'faye/websocket'
require 'ototwe/tweet_stream'
require 'json'

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

        es.on :open do |event|
          p [:open, es.url, es.last_event_id]
          @clients << es
          data = {clients: @clients.size}.to_json
          @clients.each { |client| client.send data }
        end

        es.on :close do |event|
          p [:close, es.url, es.last_event_id]
          @clients.delete(es)
          data = {clients: @clients.size}.to_json
          @clients.each { |client| client.send data }
          es = nil
        end

        EM.schedule do
          send_notes_ontweet(es)
          
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

    private
    def send_notes_ontweet(es)
      @tweet_streamer.ontweet do |tweet|
        begin
          return nil unless tweet && tweet[:user]
          user = tweet[:user][:screen_name]
          text = tweet[:text]
          tags = tweet[:entities][:hashtags]
          notes = parse_notes_in_tags(tags)
          notes = notes.map { |note| pick_a_file note }.compact
          data = {user: user, text: text, notes: notes}.to_json
          @clients.each { |client| client.send data } unless notes.empty?
          puts "\e[32m#{user}\e[0m: #{text}"
        rescue
          nil
        end
      end
      @tweet_streamer.listen
    end

    def parse_notes_in_tags(tags)
      tags.map { |h| h[:text].scan /[A-G]b?[1-6]/i }.flatten
    end

    def pick_a_file(note)
      sound_files.select { |f| f.match /^#{note}/i }.sample
    end

    def sound_files
      path = File.expand_path(File.join(__dir__, '..', 'public/sound'))
      Dir["#{path}/*.wav"].map { |path| File.basename path, '.wav' }
    end
  end
end
