class Goodreads < DataModule
  include XmlHelper

  def update
    xml_for(config.uri, '//reviews/review') do |item|
      book = Book.new_from_xml_helper(item)
      save_and_increment(book) unless Book.find_by_goodreads_id(book.goodreads_id)
    end

    puts "Fetched #{counter} new book(s)"
  end
end
