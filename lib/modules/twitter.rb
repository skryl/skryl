require 'module_base'
require 'rss_helper'

class TwitterStream < ModuleBase
  include RssHelper
  OPTS = {include_rts: true, count: 200}

  def initialize(config)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
    super
  end

  def update(opts = OPTS)
    num_updates = 0
    @client.user_timeline(opts).each do |t|
      tweet = Tweet.new(
        :content => t.full_text,
        :permalink => t.uri.to_s,
        :published_at => t.created_at,
        :guid => t.id.to_s )

      unless Tweet.find_by_permalink(tweet.permalink)
        if tweet.valid?
          tweet.save
          num_updates += 1
        else
          puts tweet.permalink
          puts tweet.errors.full_messages
        end
      end
    end
    puts "Fetched #{num_updates} new tweet(s)"
    num_updates
  end

  def initial_update
    opts = OPTS
    while update(opts) > 1
      opts = OPTS.merge(max_id: Tweet.last.guid)
    end
  end
end
