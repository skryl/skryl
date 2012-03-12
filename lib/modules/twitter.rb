require 'module_base'
require 'rss_helper'

class Twitter < ModuleBase
  include RssHelper
  OPTS = "?include_rts=true"

  def update(opts = OPTS)
    num_updates = 0
    uri = "http://twitter.com/statuses/user_timeline/#{config.user}.rss#{opts}"
    puts uri
    rss_for(uri) do |item|
      tweet = Tweet.new :content => item.title.gsub(/^[^:]+: /, ''), 
        :permalink => item.link, 
        :published_at => Time.parse(item.date.to_s),
        :guid => item.link.split('/').last
      if tweet.valid?
        tweet.save
        num_updates += 1
      end
    end
    puts "Fetched #{num_updates} new tweet(s)"
    num_updates
  end

  def initial_update
    opts = OPTS + "&count=200"
    while update(opts) > 1
      opts = OPTS + "&count=200&max_id=#{Tweet.last.guid}"
    end
  end
end
