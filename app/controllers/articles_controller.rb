class ArticlesController < ApplicationController
  caches_action :index

  def index
    @articles = Article.ordered
    @articles_count = @articles.count
    @articles_by_year = @articles.group_by{|t| t.published_at.year}
    @article_count_by_year = @articles.count_by{|a| a.published_at.beginning_of_year}

    gon.articleCountByYearCategories = [ @article_count_by_year.map{|k, v| k.strftime('%Y')}.map{ |d| "'#{d}'" }.join(', ') ]
    gon.articleCountByYearData       = [ @article_count_by_year.map{|k, v| v}.join(', ') ]
  end
end

