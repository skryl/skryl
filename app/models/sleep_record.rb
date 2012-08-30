class SleepRecord < ActiveRecord::Base 
  extend GraphStats

  SLEEP_STAGES = { 'UNDEFINED' => 0,
                   'WAKE'      => 4,
                   'REM'       => 3,
                   'LIGHT'     => 2,
                   'DEEP'      => 1 }

  set_start_time_field :bed_time
  set_duration_field :total_z_in_hours
  set_days_to_graph 30
  set_detailed_days_to_graph 10
  set_months_to_graph 6
  set_default_monthly_value 8
  set_shift_proc lambda { |s| ((s.bed_time - s.bed_time.beginning_of_day) < (s.bed_time.end_of_day - s.bed_time) ? -1.days : 0) }


  validates_presence_of :bed_time, :rise_time, :start_date, :awakenings, :awakenings_zq_points,
                        :time_in_deep, :time_in_deep_percentage, :time_in_deep_zq_points,
                        :time_in_light, :time_in_light_percentage, :time_in_rem,
                        :time_in_rem_percentage, :time_in_rem_zq_points, :time_in_wake,
                        :time_in_wake_percentage, :time_in_wake_zq_points, :time_to_z, :total_z,
                        :total_z_zq_points, :zq, :sleep_graph, :sleep_graph_start_time 

  validates_uniqueness_of :bed_time

  def graph_data
    stage_data = Array.new(4, [])
    sleep_data = sleep_graph.split(',').map { |p| p.to_i }
    stage_data[0] = sleep_data.map { |p| p == 1 ? p : 0 }
    stage_data[1] = sleep_data.map { |p| p == 2 ? p : 0 }
    stage_data[2] = sleep_data.map { |p| p == 3 ? p : 0 }
    stage_data[3] = sleep_data.map { |p| p == 4 ? p : 0 }
    stage_data
  end

  def graph_categories
    graph_data.first.map.with_index { |p, i| (bed_time + i * 5.minutes).strftime("%I:%M %p") }
  end

### 

  def self.new_from_api_response(response)
    return unless response[:sleep_record]

    r = response[:sleep_record]
    sleep_record_attributes = {
      bed_time:                     parse_api_time(r[:bed_time]),
      rise_time:                    parse_api_time(r[:rise_time]), 
      start_date:                   parse_api_time(r[:start_date]),
      awakenings:                   r[:awakenings].to_i,
      awakenings_zq_points:         r[:awakenings_zq_points].to_i,
      time_in_deep:                 r[:time_in_deep].to_i,
      time_in_deep_percentage:      r[:time_in_deep_percentage].to_i,
      time_in_deep_zq_points:       r[:time_in_deep_zq_points].to_i,
      time_in_light:                r[:time_in_light].to_i, 
      time_in_light_percentage:     r[:time_in_light_percentage].to_i, 
      time_in_rem:                  r[:time_in_rem].to_i, 
      time_in_rem_percentage:       r[:time_in_rem_percentage].to_i, 
      time_in_rem_zq_points:        r[:time_in_rem_zq_points].to_i, 
      time_in_wake:                 r[:time_in_wake].to_i, 
      time_in_wake_percentage:      r[:time_in_wake_percentage].to_i, 
      time_in_wake_zq_points:       r[:time_in_wake_zq_points].to_i, 
      time_to_z:                    r[:time_to_z].to_i, 
      total_z:                      r[:total_z].to_i, 
      total_z_zq_points:            r[:total_z_zq_points].to_i, 
      zq:                           r[:zq].to_i, 
      sleep_graph:                  parse_api_graph(r[:sleep_graph]), 
      sleep_graph_start_time:       parse_api_time(r[:sleep_graph_start_time]) }

    new(sleep_record_attributes)
  end

  def total_z_in_hours
    (total_z/60.0).round(2)
  end
  
private

  def self.parse_api_time(t, opts = {})
    t = t.with_indifferent_access
    Time.parse("#{t[:year] || '1979'}-#{t[:month] || '01'}-#{t[:day] || '01'} #{t[:hour] || '00'}:#{t[:minute] || '00'}:#{t[:second] || '00'} #{opts[:with_zone] ? '+0000' : ''}")
  end

  def self.parse_api_graph(api_graph)
    api_graph.map { |v| SLEEP_STAGES[v] }.join(',')
  end
end
