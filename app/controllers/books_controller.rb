class BooksController < ApplicationController
  caches_action :index

  def index
    @books = Book.ordered
    @book = Book.ordered.first
    @books_count = @books.count
    @books_by_year = @books.group_by{|t| t.finished_at.year}
    @book_count_by_year = @books.count_by{|b| b.finished_at.beginning_of_year}
    @page_count_by_year = @books.group_by{|b| b.finished_at.beginning_of_year}
    @page_count_by_year.merge!(@page_count_by_year){|k, v| v.sum {|i| i.num_pages.to_i } }

    gon.bookCountByYearData       = @book_count_by_year.map{|k, v| v}
    gon.bookCountByYearCategories = @book_count_by_year.map{|k, v| k.strftime('%Y')}

    gon.pageCountByYearData       = @page_count_by_year.map{|k, v| v}
    gon.pageCountByYearCategories = @page_count_by_year.map{|k, v| k.strftime('%Y')}
  end
end
