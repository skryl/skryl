class Link < ActiveRecord::Base
  scope :ordered, order('published_at DESC')

  validates_presence_of   :title, :permalink, :published_at
  validates_uniqueness_of :permalink

  scope :writing,  lambda { where(tag: 'writing') }
  scope :tech,     lambda { where(tag: 'tech') }
  scope :links,    lambda { where(tag: 'link') }
  scope :by_tag,   lambda { |tag| where(tag: tag) }

  def self.new_from_rss_helper(item)
    new :title        => item.title,
        :permalink    => item.link,
        :published_at => Time.parse(item.pubDate.to_s)
  end

end
