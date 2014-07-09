Rails.configuration.name         = Rails.application.class.parent.name
Rails.configuration.full_name    = 'Aleksey Skryl'
Rails.configuration.display_name = 'Aleksey Skryl'

Blog.configure do |mod|
  mod.atom = [ 'http://thoughts.skryl.org/rss', 'http://fiction.skryl.org/rss' ]
end

Github.configure do |mod|
  mod.user = 'skryl'
end

Goodreads.configure do |mod|
  mod.shelf   = 'read'
  mod.key     = ENV['GOODREADS_KEY']
  mod.user_id = ENV['GOODREADS_ID']
  mod.uri     = "http://www.goodreads.com/review/list/#{mod.user_id}.xml?v=2&per_page=200&shelf=read&sort=date_read&key=#{mod.key}"
end

TwitterStream.configure do |mod|
  mod.user = '_skryl_'
  mod.twitter_client = Twitter::REST::Client.new do |client|
    client.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    client.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    client.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    client.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end

Mapmyfitness.configure do |mod|
  mod.mmf_client = Mmf::Client.new do |config|
    config.client_key    = ENV['MMF_KEY']
    config.client_secret = ENV['MMF_SECRET']
    config.access_token  = ENV['MMF_TOKEN']
  end
end
