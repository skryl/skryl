class TwitterStream < DataModule
  OPTS = {include_rts: true, count: 200}

  def update(opts = OPTS)
    client = config.twitter_client
    client.user_timeline(opts).each do |item|
      tweet = Tweet.new_from_api_response(item)
      save_and_increment(tweet) unless Tweet.find_by_permalink(tweet.permalink)
    end

    puts "Fetched #{counter} new tweet(s)"
  end

  # def initial_update
  #   opts = OPTS
  #   while update(opts) > 1
  #     opts = OPTS.merge(max_id: Tweet.last.guid)
  #   end
  # end
end
