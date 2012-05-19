require 'module_base'
require 'rss_helper'

class Blog < ModuleBase
  include RssHelper

  def update
    num_updates = 0
    config.atom.each do |a|
      rss_for(a) do |item|
        blog_post = Article.new :title => item.title.content, 
          :permalink    => item.link.href, 
          :published_at => Time.parse(item.published.to_s)
        if blog_post.valid?
          blog_post.save
          num_updates += 1
        else
          puts blog_post.title
          puts blog_post.errors.full_messages
        end
      end
    end
    puts "Fetched #{num_updates} new article(s)"
  end
end
