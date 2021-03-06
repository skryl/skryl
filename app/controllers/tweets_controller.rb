class TweetsController < ApplicationController
  caches_action :index

  def index
    scope = Tweet
    scope = scope.not_mention unless tweets_params[:options] == 'with_mentions'
    @tweet_count = scope.count
    @tweet_count_by_month = scope.order('published_at ASC').count_by{|t| t.published_at.beginning_of_month}
    @tweets_by_year = scope.ordered.group_by{|t| t.published_at.year}
    @tweets_by_year = @tweets_by_year.merge(@tweets_by_year){|y, ts| ts.group_by{|t| t.published_at.month}}

    gon.tweetCountByMonthCategories = @tweet_count_by_month.map{|k, v| k.strftime("%b '%y")}
    gon.tweetCountByMonthData       = @tweet_count_by_month.map{|k, v| v}
    gon.tweetCountByMonthStep       = defined?(is_compact) && is_compact ? 2 : 1
  end

private

  def tweets_params
    params.permit(:options)
  end
end
