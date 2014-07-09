class Activity < ActiveRecord::Base
  include GraphStats

  serialize :gps_data
  serialize :hr_data
  serialize :speed_data

  validates_presence_of :activity_id, :activity_type, :start_time, :duration, :distance, :calories

  scope :past_year, where('start_time > ?', Time.now - 12.months)

  set_start_time_field :start_time
  set_duration_field :duration
  set_days_to_graph 30
  set_months_to_graph 6
  set_average_range 30

  RUN_INTERVAL = 1.seconds
  HR_INTERVAL  = 1.seconds

  RUN_DY_CUTOFF = 30
  HR_DY_CUTOFF  = 30

  RUN_INTERVAL_REDUCTION = 10
  HR_INTERVAL_REDUCTION  = 2

  MPS_TO_MPH = 2.237

  def self.new_from_api_response(response)
    new activity_id:         response['_links']['self'].first['id'].to_s,
        activity_type:       response['name'] == 'Treadmill' ? 'HEARTRATE' : 'RUN',
        start_time:          Time.parse(response['start_datetime']),
        duration:            response['aggregates']['elapsed_time_total']/60.0,
        distance:            0,
        calories:            0,
        gps_data:            parse_gps_data(response),
        hr_data:             parse_hr_data(response),
        speed_data:          parse_speed_data(response)
  end

  def self.parse_gps_data(response)
    return [] unless response['time_series'].include?('position')
    response['time_series']['position'].map {|time, val| val}
  end

  def self.parse_hr_data(response)
    return [] unless response['time_series'].include?('heartrate')
    response['time_series']['heartrate'].map {|time, val| val}
  end

  def self.parse_speed_data(response)
    return [] unless response['time_series'].include?('speed')
    response['time_series']['speed'].map {|time, val| val * MPS_TO_MPH}
  end

  def initialize(attrs)
    super
    @reduce_factor, @data_interval, @dy_cutoff = run? ?
      [RUN_INTERVAL_REDUCTION, RUN_INTERVAL, RUN_DY_CUTOFF] :
      [HR_INTERVAL_REDUCTION, HR_INTERVAL, HR_DY_CUTOFF]
  end

  def graph_data
    @graph_data ||= run? ? normalize(speed_data) : normalize(hr_data)
  end

  def graph_intervals
    @intervals ||= graph_data.map.with_index { |p, i| (start_time + i * (@reduce_factor * @data_interval)).strftime("%I:%M %p") }
  end

private

  def normalize(graph_data)
    return [] unless graph_data
    reduce( fix_zeroes( graph_data.map {|p| p.to_i} ) )
  end

  def run?
    activity_type == 'RUN'
  end

end
