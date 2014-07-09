class Mapmyfitness < DataModule

  def update
    client = config.mmf_client
    args   = Activity.any? ? {started_after: Activity.last.start_time.xmlschema} : {}
    activities = client.workouts(args)

    activities.each do |a|
      id = a['_links']['self'].first['id'].to_s
      activity = client.workout(workout_id: id, field_set: 'time_series')
      save_and_increment(Activity.new_from_api_response(activity)) unless
          Activity.find_by_activity_id(id)
    end

    puts "Fetched #{counter} new activities"
  end

end
