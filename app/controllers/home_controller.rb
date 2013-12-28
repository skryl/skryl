class HomeController < ApplicationController
  caches_action :index

  def index
    @actions                 = GithubAction.ordered.limit(10)
    @action_count_by_month   = GithubAction.order('published_at ASC').count_by {|a| a.published_at.beginning_of_month}
    @articles                = Article.ordered.limit(5)
    @book                    = Book.ordered.first
    @book_count_by_year      = Book.ordered.count_by{|b| b.finished_at.beginning_of_year}
    @tweet_count             = Tweet.last_year.not_mention.count
    @tweet_count_by_month    = Tweet.last_year.not_mention.order('published_at ASC').count_by {|t| t.published_at.beginning_of_month}
    @tweets                  = Tweet.not_mention.ordered.limit(5)
    @sleep_count             = SleepRecord.average_by_month
    @exercise_count          = Activity.average_by_month

    gon.bookCountByYearData       = @book_count_by_year.map{|k, v| v}
    gon.bookCountByYearCategories = @book_count_by_year.map{|k, v| k.strftime('%Y')}.map{ |d| "'#{d}'" }

    gon.tweetCountByMonthCategories = @tweet_count_by_month.map{|k, v| "'#{k.strftime("%b \\'%y")}'"}
    gon.tweetCountByMonthData       = @tweet_count_by_month.map{|k, v| v}
    gon.tweetCountByMonthStep       = defined?(is_compact) && is_compact ? 2 : 1

    gon.actionCountByMonthCategories = @action_count_by_month.map{|k, v| "'#{k.strftime("%b \\'%y")}'"}
    gon.actionCountByMonthData       = @action_count_by_month.map{|k, v| v}
    gon.actionCountByMonthStep       = defined?(is_compact) && is_compact ? 2 : 1

    gon.exerciseChartCategories = @exercise_count.map{|k, v| "'#{k.strftime("%b %d")}'"}
    gon.exerciseChartData       = @exercise_count.map{|k, v| v}
  end
end
