class Pocket < DataModule
  include RssHelper

  def update
    config.atom.each do |a|
      rss_for(a) do |item|
        blog_post = Link.new_from_rss_helper(item)
        save_and_increment(blog_post) unless
            Link.find_by_permalink(blog_post.permalink)
      end
    end

    puts "Fetched #{counter} new read article(s)"
  end

end
