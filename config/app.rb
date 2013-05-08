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
    mod.key     = ENV['GOODREADS_KEY']
    mod.shelf   = 'read'
    mod.user_id = ENV['GOODREADS_ID']
  end

  for_module(:twitter) do |mod|
    mod.user = '_skryl_'
  end

  for_module(:zeo) do |mod|
    MyZeo.headers 'Referer' => 'http://skryl.org'
    mod.zeo_client = MyZeo.new(ENV['ZEO_KEY'], :login => ENV['ZEO_LOGIN'], :password => ENV['ZEO_PASSWORD'])
  end

  for_module(:nike_plus) do |mod|
    mod.nike_client = Nike::Client.new(ENV['NIKE_TOKEN'])
  end
end
