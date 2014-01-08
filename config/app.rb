require 'app_extensions'
require 'heroku_env'

class App < Configurable # :nodoc:
  extend AppExtensions

  # Settings in config/app/* take precedence over those specified here.
  config.name = Rails.application.class.parent.name

  # Personal information
  config.full_name    = 'Aleksey Skryl'
  config.display_name = 'Aleksey Skryl'

  for_module(:blog) do |mod|
    mod.atom = [ 'http://thoughts.skryl.org/rss', 'http://fiction.skryl.org/rss' ]
  end

  for_module(:github) do |mod|
    mod.user = 'skryl'
  end

  for_module(:goodreads) do |mod|
    mod.shelf   = 'read'
    mod.key     = ENV['GOODREADS_KEY']
    mod.user_id = ENV['GOODREADS_ID']
  end

  for_module(:twitter_stream) do |mod|
    mod.user = '_skryl_'
  end

  # for_module(:nike_plus) do |mod|
  #   mod.nike_client = Nike::Client.new(ENV['NIKE_TOKEN'])
  # end

  for_module(:mapmyfitness) do |mod|
    mod.mmf_client = Mmf::Client.new do |config|
      config.client_key    = ENV['MMF_KEY']
      config.client_secret = ENV['MMF_SECRET']
      config.access_token  = ENV['MMF_TOKEN']
    end
  end

end
