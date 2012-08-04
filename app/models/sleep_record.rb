class SleepRecord < ActiveRecord::Base

  SLEEP_STAGES = { 'UNDEFINED' => 0,
                   'WAKE'      => 4,
                   'REM'       => 3,
                   'LIGHT'     => 2,
                   'DEEP'      => 1 }


  validates_presence_of :bed_time, :rise_time, :start_date, :awakenings, :awakenings_zq_points,
                        :time_in_deep, :time_in_deep_percentage, :time_in_deep_zq_points,
                        :time_in_light, :time_in_light_percentage, :time_in_rem,
                        :time_in_rem_percentage, :time_in_rem_zq_points, :time_in_wake,
                        :time_in_wake_percentage, :time_in_wake_zq_points, :time_to_z, :total_z,
                        :total_z_zq_points, :zq, :sleep_graph, :sleep_graph_start_time 

  validates_uniqueness_of :bed_time

  def method_missing(name, *args, &block)
    case name
    when /(.*)_in_hours$/ 
      (send($1)/60.0).round(2)
    else super
    end
  end
  
  def self.sleep_records_by_day
    SleepRecord.order('bed_time ASC').group_by { |s| s.bed_time.to_date }
  end

  def self.slept_hours_by_day
    sleep_records_by_day.inject({}) do |h, (date, records)| 
      h[date.to_date] = records.map { |r| r.total_z_in_hours }.sum; h
    end
  end

  def self.slept_hours_for_available_dates
    date_range = (self.minimum(:bed_time).to_date .. Date.today-30)
    hours_by_day = date_range.inject({}) { |h, d| h[d] = 0; h }
    hours_by_day.merge(slept_hours_by_day).reject { |d,h| d < Date.today - 60 }
  end

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

private

  def self.parse_api_time(t)
    t = t.with_indifferent_access
    Time.parse("#{t[:year] || '1979'}-#{t[:month] || '01'}-#{t[:day] || '01'} #{t[:hour] || '00'}:#{t[:minute] || '00'}:#{t[:second] || '00'}")
  end

  def self.parse_api_graph(api_graph)
    api_graph.map { |v| SLEEP_STAGES[v] }.join(',')
  end
end
