require 'module_base'

class NikePlus < ModuleBase

  def update
    num_updates = 0
    client = config.nike_client
    activities = client.activities(type: :run) + client.activities(type: :hr)

    activities.each do |a|
      unless Activity.find_by_activity_id(a.activity_id)
        activity = Activity.new_from_api_response(client.activity(a.activity_id))
        if activity.valid?
          activity.save
          num_updates += 1
        else
          puts activity.activity_id
          puts activity.errors.full_messages
        end
      end
    end

    puts "Fetched #{num_updates} new activities"
  end

end
