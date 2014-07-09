module GraphStats

  def self.included(klass)
    klass.extend(ClassMethods)
  end

private

  def fix_zeroes(graph_data)
    data = []
    graph_data.inject do |p_prev,p|
      data.push(
        if p < 0
          p_prev
        elsif p_prev - p > @dy_cutoff
          p_prev - 1
        else p
        end
      ); data.last
    end
    data
  end

  def reduce(graph_data, factor = nil)
    reduce_factor = factor || @reduce_factor
    return graph_data if reduce_factor == 1
    data = []
    graph_data.each_slice(reduce_factor) { |s| data << (s.sum/s.size) }
    data
  end

module ClassMethods

  def set_start_time_field(field)
    @start_time_field = field
    scope :ordered, order("#{field} ASC")
    scope :last_n_days, lambda { |n| where("#{field} > ?", (Date.today - n)) }
    scope :last_n_months, lambda { |n| where("#{field} > ?", (Date.today.end_of_month - (n-1).months)) }
  end

  def set_end_time_field(field)
    @end_time_field = field
  end

  def set_duration_field(field)
    @duration_field = field
  end

  def set_days_to_graph(days)
    @days_to_graph = days
  end

  def set_detailed_days_to_graph(days)
    @detailed_days_to_graph = days
  end

  def set_months_to_graph(months)
    @months_to_graph = months
  end

  def set_average_range(range)
    @average_range = range
  end

  def set_default_monthly_value(val)
    @default_monthly_value = val
  end

  def set_default_daily_value(val)
    @default_daily_value = val
  end

  def set_shift_proc(p)
    @shift_proc = p
  end

  def set_shift_max(s)
    @shift_max = s
  end

# daily stats

  def activity_to_graph
    last_n_days(@days_to_graph).ordered
  end

  def activity_by_day
    day_shift activity_to_graph.group_by { |s| s.send(@start_time_field).to_date }
  end

  def total_by_day
    activity_by_day.inject({}) do |h, (date, records)|
      h[date.to_date] = records.map { |r| r.send(@duration_field) }.sum.round(2); h
    end
  end

  def graph_total_by_day
    empty_days_to_graph.merge(total_by_day)
  end

  def start_time_by_day
    activity_by_day.inject({}) do |h, (date, records)|
      start_time = records.first.send(@start_time_field); h
      h[date.to_date] = (start_time.hour + start_time.min / 60.0).round(2); h
    end
  end

  def graph_start_time_by_day
    empty_days_to_graph.merge(start_time_by_day)
  end

  def end_time_by_day
    activity_by_day.inject({}) do |h, (date, records)|
      end_time = records.first.send(@end_time_field); h
      h[date.to_date] = (end_time.hour + end_time.min / 60.0).round(2); h
    end
  end

  def graph_end_time_by_day
    empty_days_to_graph.merge(end_time_by_day)
  end

# monthly stats

  def activity_by_month
    last_n_months(@months_to_graph).group_by { |s| s.send(@start_time_field).beginning_of_month }
  end

  def average_by_month
    activity_time_by_month = activity_by_month.inject({}) do |h, (date, records)|
      h[date.to_date] = (records.map { |r| r.send(@duration_field) }.sum / (@average_range || records.size)).round(2); h
    end
    empty_months_to_graph.merge(activity_time_by_month)
  end

# yearly stats

  def detailed_activity_to_graph
    last_n_days(@detailed_days_to_graph || @days_to_graph).ordered
  end

  def activity_by_year
    detailed_activity_to_graph.group_by{|t| t.send(@start_time_field).year}
  end

  def activity_by_year_month
    activity_by_year = self.activity_by_year
    activity_by_year.merge(activity_by_year){ |y, ts| ts.group_by { |s| s.send(@start_time_field).month }}
  end

private

  # subtract one to account for potential shift
  #
  def empty_days_to_graph
    ((Date.today - @days_to_graph - (@shift_max || 0) - 1) .. Date.today).inject({}) { |h, d| h[d] = @default_daily_value || 0; h }
  end

  def empty_months_to_graph
    (0...@months_to_graph).to_a.reverse.inject({}) { |h, m_ago| h[(Date.today - m_ago.months).beginning_of_month] = @default_monthly_value || 0; h }
  end

  def day_shift(activity_by_day)
    return activity_by_day unless @shift_proc
    h = Hash.new {|h,k| h[k] = []}
    activity_by_day.inject(h) { |h, (k,v)| v.each { |i| h[k + @shift_proc[i]] << i }; h }
  end
end

end
