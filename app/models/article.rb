class Article < ActiveRecord::Base
  scope :ordered, order('published_at DESC')

  validates_presence_of   :title, :permalink, :published_at
  validates_uniqueness_of :permalink

  def self.new_from_rss_helper(item)
    new :title        => item.title,
        :permalink    => item.link,
        :published_at => Time.parse(item.pubDate.to_s)
  end
end
