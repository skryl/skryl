class Activity < ActiveRecord::Base
  extend GraphStats
  
  serialize :gps_data
  serialize :hr_data
  serialize :speed_data

  validates_presence_of :activity_id, :activity_type, :start_time, :duration, :distance, :calories 

  set_start_time_field :start_time
  set_duration_field :duration
  set_days_to_graph 30
  set_months_to_graph 6
  set_average_range 30

  GPS_INTERVAL = 10.seconds
  HR_INTERVAL = 10.seconds

  RUN_REDUCE_FACTOR = 2
  RUN_DY_CUTOFF = 7

  HR_REDUCE_FACTOR = 2
  HR_DY_CUTOFF = 30

  KPH_TO_MPH = 0.621

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
    speed_data['values'].map { |kph| kph * KPH_TO_MPH } if speed_data
  end

# breakdown graphs

  def graph_data
    @graph_data ||= run? ? normalize(speed_data) : normalize(hr_data)
  end

  def graph_categories
    reduce_factor = (run? ? RUN_REDUCE_FACTOR : HR_REDUCE_FACTOR)
    data_interval = (run? ? GPS_INTERVAL : HR_INTERVAL)
    @categories ||= graph_data.map.with_index { |p, i| (start_time_fixed + i * (reduce_factor * data_interval)).strftime("%I:%M %p") }
  end

 private
 
  def run?
    activity_type == 'RUN'
  end

  def normalize(graph_data)
    return [] unless graph_data
    reduce( fix_zeroes( graph_data.map {|p| p.to_i} ) )
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

  # Time is synced incorrectly on the sportband for some reason
  #
  def start_time_fixed
    start_time - (run? ? 0 : (start_time.isdst ? 1.hours : 1))
  end


end
