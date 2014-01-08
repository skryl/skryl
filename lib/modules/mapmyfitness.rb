require 'module_base'

class Mapmyfitness < ModuleBase

  def update
    num_updates = 0
    client = config.mmf_client
    activities = client.workouts(user: client.me['id'])['_embedded']['workouts']

    activities.each do |a|
      id = a['_links']['self'].first['id']
      unless Activity.find_by_activity_id(id)
        activity = Activity.new_from_api_response(client.workout(workout_id: id, field_set: 'time_series'))
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

