env = YAML::load_file(Rails.root.join('.env.yaml'))
env.each { |k,v| ENV[k.to_s] = v }
