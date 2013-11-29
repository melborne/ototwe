require 'app'
require 'ototwe/backend'
require 'yaml'

auth = YAML.load_file('auth.yaml')
terms = ['#ototo']

use OtoTwe::Backend, track_terms: terms, auth: auth

run OtoTwe::App
