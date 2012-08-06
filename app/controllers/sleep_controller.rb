class SleepController < ApplicationController
  caches_action :index

  def index
    @sleep_count           = SleepRecord.sleep_count_by_day
    @sleep_by_year_month   = SleepRecord.sleep_records_by_year_month
    @sleep_records_to_graph = SleepRecord.sleep_records_to_graph
    gon.sleep_breakdown_chart_categories = @sleep_records_to_graph.inject({}) { |h,r| h[r.id] = r.graph_categories; h }
    gon.sleep_breakdown_chart_data  = @sleep_records_to_graph.inject({}) {|h, r| h[r.id] = r.graph_data; h}
  end

end
