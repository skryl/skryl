class Github < DataModule
  include RssHelper

  def update
    rss_for("https://github.com/#{config.user}.atom") do |item|
      action = GithubAction.new_from_rss_helper(item)
      save_and_increment(action) unless GithubAction.find_by_github_id(action.github_id)
    end

    puts "Fetched #{counter} new action(s)"
  end
end
