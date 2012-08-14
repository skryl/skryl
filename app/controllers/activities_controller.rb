class ActivitiesController < ApplicationController
  caches_action :index

  def index
    @exercise_count           = Activity.graph_total_by_day
    @activity_by_year_month   = Activity.activity_by_year_month
    @activity_to_graph        = Activity.activity_to_graph
    # gon.sleep_breakdown_chart_categories = @sleep_records_to_graph.inject({}) { |h,r| h[r.id] = r.graph_categories; h }
    # gon.sleep_breakdown_chart_data  = @sleep_records_to_graph.inject({}) {|h, r| h[r.id] = r.graph_data; h}
  end

end
