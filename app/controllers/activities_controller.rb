class ActivitiesController < ApplicationController
  caches_action :index

  def index
    @exercise_count           = Activity.graph_total_by_day
    @activity_by_year_month   = Activity.activity_by_year_month
    @activity_to_graph        = Activity.activity_to_graph
    gon.exerciseChartCategories = @exercise_count.map{|k, v| k.strftime("%b %d")}
    gon.exerciseChartData       = @exercise_count.map{|k, v| v}
    gon.activity_breakdown_chart_categories = @activity_to_graph.inject({}) { |h,r| h[r.id] = r.graph_intervals; h }
    gon.activity_breakdown_chart_data  = @activity_to_graph.inject({}) {|h, r| h[r.id] = r.graph_data; h}
    # gon.activity_breakdown_geo_data  = @activity_to_graph.inject({}) {|h, r| h[r.id] = r.geo_data; h}
  end

end
