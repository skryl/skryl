class GithubAction < ActiveRecord::Base
  scope :ordered, order('published_at DESC')
  scope :past_year, where('published_at > ?', Time.now - 12.months)

  validates_presence_of :github_id, :title, :permalink, :published_at, :content
  validates_uniqueness_of :github_id

  def content_html
    content.gsub /href\s*=\s*["']([^(http)].*?)["']/, 'href="https://github.com\1"'
  end
end
