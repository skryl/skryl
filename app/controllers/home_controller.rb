class HomeController < ApplicationController
  caches_action :index

  def index
    @actions                 = GithubAction.ordered.limit(3)
    @action_count_by_month   = GithubAction.order('published_at ASC').count_by {|a| a.published_at.beginning_of_month}
    @articles                = Article.ordered.limit(5)
    @book                    = Book.ordered.first
    @book_count_by_year      = Book.ordered.count_by{|b| b.finished_at.beginning_of_year}
    @tweet_count             = Tweet.not_mention.count
    @tweet_count_by_month    = Tweet.not_mention.order('published_at ASC').count_by {|t| t.published_at.beginning_of_month}
    @tweets                  = Tweet.not_mention.ordered.limit(10)
    @sleep_count             = SleepRecord.sleep_average_by_month
  end
end
