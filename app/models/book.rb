class Book < ActiveRecord::Base
  EVERNOTE_BASE = "https://www.evernote.com/shard/s6/sh"

  has_many :authors, :class_name => 'BookAuthor'

  scope :ordered, order('finished_at DESC')

  validates_presence_of   :goodreads_id, :title, :finished_at
  validates_uniqueness_of :goodreads_id

  def self.new_from_xml_helper(item)
    note_path = item.find('recommended_for').first.content

    book = \
      new :goodreads_id => item.find('book/id').first.content,
          :isbn13       => item.find('book/isbn13').first.content,
          :title        => item.find('book/title').first.content.strip,
          :finished_at  => Time.parse(item.find('read_at').first.content),
          :num_pages    => item.find('book/num_pages').first.content,
          :rating       => item.find('rating').first.content,
          :notes_url    => note_path.blank? ? nil : "#{EVERNOTE_BASE}/#{note_path}"

    item.find('book/authors/author').each do |a|
      book.add_author(a.find('name').first.content.strip)
    end

    book
  end

  def add_author(name)
    self.authors << BookAuthor.new(:name => name)
  end

  def author
    if self.authors.size > 1
      author_parts = self.authors.order('name ASC').map{|a| a.name}.intersperse(', ')
      author_parts[author_parts.size - 2] = ', and '
      author_parts.join
    elsif self.authors.size == 1
      self.authors.first.name
    else
      nil
    end
  end
end
