class Activity < ActiveRecord::Base
  
  serialize :gps_data
  serialize :hr_data
  serialize :speed_data

  validates_presence_of :activity_id, :activity_type, :start_time, :status, :device_type, :duration, :distance, :calories 

  scope :ordered, order('start_time DESC')
  scope :last_n_days, lambda { |n| where("start_time > ?", (Date.today - n)) }

  DAYS_TO_GRAPH = 60

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
    Activity.all.group_by { |s| s.start_time.beginning_of_month }
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


end
