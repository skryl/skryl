class SleepRecord < ActiveRecord::Base 

  scope :ordered, order('bed_time DESC')
  scope :enough_data, where('length(sleep_graph) > 25')
  scope :last_n_days, lambda { |n| where("bed_time > ?", (Date.today - n)) }

  SLEEP_STAGES = { 'UNDEFINED' => 0,
                   'WAKE'      => 4,
                   'REM'       => 3,
                   'LIGHT'     => 2,
                   'DEEP'      => 1 }

  DAYS_TO_GRAPH = 60


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
    graph_data.first.map.with_index { |p, i| (bed_time + i * 20.minutes).strftime("%I:%M %p") }
  end

# daily stats

  def self.sleep_records_to_graph
    SleepRecord.last_n_days(DAYS_TO_GRAPH).enough_data.ordered
  end

  def self.sleep_records_by_day
    sleep_records_to_graph.group_by { |s| s.bed_time.to_date }
  end

  def self.slept_hours_by_day
    sleep_records_by_day.inject({}) do |h, (date, records)| 
      h[date.to_date] = records.map { |r| r.total_z_in_hours }.sum; h
    end
  end

  def self.sleep_count_by_day
    date_range = ((Date.today - DAYS_TO_GRAPH) .. Date.today)
    hours_by_day = date_range.inject({}) { |h, d| h[d] = 0; h }
    hours_by_day.merge(slept_hours_by_day)
  end

# monthly stats

  def self.sleep_records_by_month
    SleepRecord.all.group_by { |s| s.bed_time.beginning_of_month }
  end

  def self.sleep_average_by_month
    sleep_records_by_month.inject({}) do |h, (date, records)| 
      h[date.to_date] = (records.map { |r| r.total_z_in_hours }.sum / records.size).round(2); h
    end
  end

# yearly stats

  def self.sleep_records_by_year
    sleep_records_to_graph.group_by{|t| t.bed_time.year}
  end

  def self.sleep_records_by_year_month
    sleep_by_year = sleep_records_by_year
    sleep_by_year.merge(sleep_by_year){|y, ts| ts.group_by{|t| t.bed_time.month}}
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

  def method_missing(name, *args, &block)
    case name
    when /(.*)_in_hours$/ 
      (send($1)/60.0).round(2)
    else super
    end
  end
  
private

  def self.parse_api_time(t)
    t = t.with_indifferent_access
    Time.parse("#{t[:year] || '1979'}-#{t[:month] || '01'}-#{t[:day] || '01'} #{t[:hour] || '00'}:#{t[:minute] || '00'}:#{t[:second] || '00'}")
  end

  def self.parse_api_graph(api_graph)
    api_graph.map { |v| SLEEP_STAGES[v] }.join(',')
  end
end
