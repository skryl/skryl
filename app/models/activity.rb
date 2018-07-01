class Activity < ActiveRecord::Base
  include GraphStats

  serialize :gps_data
  serialize :hr_data
  serialize :speed_data

  validates_presence_of :activity_id, :activity_type, :start_time, :duration, :distance, :calories

  scope :past_year, -> { where('start_time > ?', Time.now - 12.months) }

  set_start_time_field :start_time
  set_duration_field :duration
  set_days_to_graph 30
  set_months_to_graph 6
  set_average_range 30

  HR_INTERVAL  = 1.seconds
  HR_DY_CUTOFF  = 30
  HR_INTERVAL_REDUCE = 4

  SPEED_INTERVAL = 1.seconds
  SPEED_DY_CUTOFF = 30
  SPEED_INTERVAL_REDUCE = 8

  MPS_TO_MPH = 2.237
  LONG_SESSION = 5000

  CONSTANTS = {
    reduce_factor: [SPEED_INTERVAL_REDUCE, HR_INTERVAL_REDUCE],
    data_interval: [SPEED_INTERVAL, HR_INTERVAL],
    dy_cutoff:     [SPEED_DY_CUTOFF, HR_DY_CUTOFF]
  }

  def self.new_from_api_response(response)
    new activity_id:    response['_links']['self'].first['id'].to_s,
        activity_type:  response['name'] == 'Treadmill' ? 'HEARTRATE' : 'RUN',
        start_time:     Time.parse(response['start_datetime']),
        duration:       response['aggregates']['elapsed_time_total']/60.0,
        distance:       0,
        calories:       0,
        gps_data:       parse_gps_data(response),
        hr_data:        parse_hr_data(response),
        speed_data:     parse_speed_data(response)
  end

  def self.parse_gps_data(response)
    return [] unless response['time_series'] && response['time_series'].include?('position')
    response['time_series']['position'].map {|time, val| val}
  end

  def self.parse_hr_data(response)
    return [] unless response['time_series'] && response['time_series'].include?('heartrate')
    response['time_series']['heartrate'].map {|time, val| val}
  end

  def self.parse_speed_data(response)
    return [] unless response['time_series'] && response['time_series'].include?('speed')
    response['time_series']['speed'].map {|time, val| val * MPS_TO_MPH}
  end

  def graph_data
    @graph_data ||= missing_hr? ? normalize(speed_data) : normalize(hr_data)
  end

  def graph_intervals
    @intervals ||= graph_data.map.with_index { |p, i| (start_time + i * (reduce_factor * data_interval)).strftime("%I:%M %p") }
  end

  def reduce_factor
    @reduce_factor ||= choose_constant(:reduce_factor) * (long_session? ? 2 : 1)
  end

  def data_interval
    @data_interval ||= choose_constant(:data_interval)
  end

  def dy_cutoff
    @dy_cutoff ||= choose_constant(:dy_cutoff)
  end

  def missing_hr?
    hr_data.empty?
  end

private

  def normalize(graph_data)
    return [] unless graph_data
    reduce( fix_zeroes( graph_data.map {|p| p.to_i} ) )
  end

  def choose_constant(name)
    CONSTANTS[name][missing_hr? ? 0 : 1]
  end

  def long_session?
    speed_data.size > LONG_SESSION || hr_data.size > LONG_SESSION
  end

end
