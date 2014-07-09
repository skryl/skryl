class Blog < DataModule
  include RssHelper

  def update
    config.atom.each do |a|
      rss_for(a) do |item|
        blog_post = Article.new_from_rss_helper(item)
        save_and_increment(blog_post) unless
            Article.find_by_permalink(blog_post.permalink)
      end
    end

    puts "Fetched #{counter} new article(s)"
  end

end
