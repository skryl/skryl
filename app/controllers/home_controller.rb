class HomeController < ApplicationController
  caches_action :index

  def index
    @actions                 = GithubAction.ordered.limit(10)
    @action_count_by_month   = GithubAction.past_year.order('published_at ASC').count_by {|a| a.published_at.beginning_of_month}
    @writings                = Link.writing.ordered.limit(5)
    @tech                    = Link.tech.ordered.limit(5)
    @links                   = Link.links.ordered.limit(5)
    @book                    = Book.ordered.first
    @book_count_by_year      = Book.ordered.count_by{|b| b.finished_at.beginning_of_year}
    @tweet_count             = Tweet.past_year.not_mention.count
    @tweet_count_by_month    = Tweet.past_year.not_mention.order('published_at ASC').count_by {|t| t.published_at.beginning_of_month}
    @tweets                  = Tweet.not_mention.ordered.limit(5)
    @exercise_count          = Activity.past_year.average_by_month

    gon.bookCountByYearData          = @book_count_by_year.map{|k, v| v}
    gon.bookCountByYearCategories    = @book_count_by_year.map{|k, v| k.strftime('%Y')}

    gon.tweetCountByMonthCategories  = @tweet_count_by_month.map{|k, v| k.strftime("%b '%y")}
    gon.tweetCountByMonthData        = @tweet_count_by_month.map{|k, v| v}
    gon.tweetCountByMonthStep        = defined?(is_compact) && is_compact ? 2 : 1

    gon.actionCountByMonthCategories = @action_count_by_month.map{|k, v| k.strftime("%b '%y")}
    gon.actionCountByMonthData       = @action_count_by_month.map{|k, v| v}
    gon.actionCountByMonthStep       = defined?(is_compact) && is_compact ? 2 : 1

    gon.exerciseChartCategories      = @exercise_count.map{|k, v| k.strftime("%b '%y")}
    gon.exerciseChartData            = @exercise_count.map{|k, v| v}
  end
end
