require 'module_base'

class Zeo < ModuleBase

  def update
    num_updates = 0
    client = config.zeo_client
    last_record_date = SleepRecord.maximum(:start_date) || Date.parse('1979-01-01')
    date_list = client.get_dates_with_sleep_data_in_range(:date_from => last_record_date.strftime)[:response][:date_list]

    date_list && [date_list[:date]].flatten.each do |d|
      date = SleepRecord.parse_api_time(d).to_date
      sleep_record = \
        SleepRecord.new_from_api_response( client.get_sleep_record_for_date(:date => date.strftime)[:response] )

      if sleep_record
        if sleep_record.valid?
          sleep_record.save
          num_updates += 1
        else
          puts sleep_record.bed_time
          puts sleep_record.errors.full_messages
        end
      else
        puts "Could not parse sleep record!"
      end
    end

    puts "Fetched #{num_updates} new sleep record(s)"
  end

end
