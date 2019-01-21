class Link < ActiveRecord::Base
  validates_presence_of   :title, :permalink, :published_at
  validates_uniqueness_of :permalink

  scope :ordered,  -> { order('published_at DESC') }
  scope :writing,  -> { where(tag: 'writing') }
  scope :links,    -> { where(tag: 'link') }
  scope :by_tag,   ->(tag) { where(tag: tag) }

  def self.new_from_rss_helper(item)
    new :title        => item.title.content,
        :permalink    => item.link.href,
        :published_at => item.updated.content
  end

end
