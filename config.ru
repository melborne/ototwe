require 'app'
require 'ototwe/backend'
require 'yaml'

def read_auth
  YAML.load_file('auth.yaml')
rescue Errno::ENOENT
  { consumer_key: ENV['TWITTER_CONSUMER_KEY'],
    consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
    access_token: ENV['TWITTER_ACCESS_TOKEN'],
    access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET'] }
end
terms = ['#ototo']

use OtoTwe::Backend, track_terms: terms, auth: read_auth

run OtoTwe::App
