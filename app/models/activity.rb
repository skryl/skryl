class Activity < ActiveRecord::Base
  
  serialize :gps_data
  serialize :hr_data
  serialize :speed_data

  validates_presence_of :activity_id, :activity_type, :start_time, :duration, :distance, :calories 

  scope :ordered, order('start_time DESC')
  scope :last_n_days, lambda { |n| where("start_time > ?", (Date.today - n)) }
  scope :last_n_months, lambda { |n| where("start_time > ?", (Date.today - n.months)) }

  DAYS_TO_GRAPH = 30
  MONTHS_TO_GRAPH = 6

  RUN_REDUCE_FACTOR = 4
  RUN_DY_CUTOFF = 7

  HR_REDUCE_FACTOR = 2
  HR_DY_CUTOFF = 30

  def self.new_from_api_response(response)
    return unless response

    activity_attributes = {
      activity_id:         response.activity_id,
      activity_type:       response.activity_type,
      start_time:          response.start_time_utc,
      status:              response.status,
      gps:                 response.gps,
      latitude:            response.latitude,
      longitude:           response.longitude,
      heartrate:           response.heartrate,
      device_type:         response.device_type,
      duration:            response.duration_in_minutes,
      distance:            response.distance_in_miles,
      calories:            response.calories,
      gps_data:            parse_gps_data(response),
      hr_data:             parse_hr_data(response),
      speed_data:          parse_speed_data(response)
    }

    new(activity_attributes)
  end

  def self.parse_gps_data(response)
    response.geo.waypoints if response.geo
  end

  def self.parse_hr_data(response)
    hr_data = response.history.detect { |h| h.type == 'HEARTRATE' }
    hr_data['values'] if hr_data
  end

  def self.parse_speed_data(response)
    speed_data = response.history.detect { |h| h.type == 'SPEED' }
    speed_data['values'] if speed_data
  end

# breakdown graphs

  def graph_data
    @graph_data ||= run? ? normalize(speed_data) : normalize(hr_data)
  end

  # def geo_data
  #   return [] unless gps_data
  #   geo = Array.new(3, [])
  #   gps_data.each do |h| 
  #     geo[0] << h['lat']
  #     geo[1] << h['lon']
  #     geo[2] << h['ele']
  #   end
  #   reduce(geo[2], (geo[2].size/graph_data.size).to_i)
  # end

  def graph_categories
    reduce_factor = (run? ? RUN_REDUCE_FACTOR : HR_REDUCE_FACTOR)
    @categories ||= graph_data.map.with_index { |p, i| (start_time + i * (reduce_factor * 10.seconds)).strftime("%I:%M %p") }
  end

# daily stats

  def self.activity_to_graph
    Activity.last_n_days(DAYS_TO_GRAPH).ordered
  end

  def self.activity_by_day
    activity_to_graph.group_by { |s| s.start_time.to_date }
  end

  def self.total_by_day
    activity_by_day.inject({}) do |h, (date, records)| 
      h[date.to_date] = records.map { |r| r.duration }.sum.round(2); h
    end
  end

  def self.graph_total_by_day
    date_range = ((Date.today - DAYS_TO_GRAPH) .. Date.today)
    hours_by_day = date_range.inject({}) { |h, d| h[d] = 0; h }
    hours_by_day.merge(total_by_day)
  end

# monthly stats

  def self.activity_by_month
    Activity.last_n_months(MONTHS_TO_GRAPH).group_by { |s| s.start_time.beginning_of_month }
  end

  def self.average_by_month
    activity_by_month.inject({}) do |h, (date, records)| 
      h[date.to_date] = (records.map { |r| r.duration }.sum / 30).round(2); h
    end
  end

# yearly stats

  def self.activity_by_year
    activity_to_graph.group_by{|t| t.start_time.year}
  end

  def self.activity_by_year_month
    activity_by_year = self.activity_by_year
    activity_by_year.merge(activity_by_year){|y, ts| ts.group_by{|t| t.start_time.month}}
  end

private

  def run?
    activity_type == 'RUN'
  end

  def normalize(graph_data)
    return [] unless graph_data
    reduce(
      fix_zeroes(
        graph_data.map {|p| p.to_i} ))
  end

  def fix_zeroes(graph_data)
    dy_cutoff = (run? ? RUN_DY_CUTOFF : HR_DY_CUTOFF)
    data = []
    graph_data.inject do |p_prev,p|
      data.push(
        if p < 0
          p_prev
        elsif p_prev - p > dy_cutoff
          p_prev - 1
        else p
        end
      ); data.last
    end
    data
  end

  def reduce(graph_data, factor = nil)
    reduce_factor = factor || (run? ? RUN_REDUCE_FACTOR : HR_REDUCE_FACTOR)
    return graph_data if reduce_factor == 1
    data = []
    graph_data.each_slice(reduce_factor) { |s| data << (s.sum/s.size) }
    data
  end

end
