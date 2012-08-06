require 'module_base'
require 'rss_helper'

class Github < ModuleBase
  include RssHelper

  def update
    num_updates = 0
    rss_for("https://github.com/#{config.user}.atom") do |item|
      action = GithubAction.new :github_id => item.id.content, 
        :title        => item.title.content, 
        :permalink    => item.link.href, 
        :published_at => Time.parse(item.published.to_s), 
        :content      => item.content.content
      unless GithubAction.find_by_github_id(action.github_id)
        if action.valid?
          action.save
          num_updates += 1
        else
          puts action.title
          puts action.errors.full_messages
        end
      end
    end
    puts "Fetched #{num_updates} new action(s)"
  end
end
