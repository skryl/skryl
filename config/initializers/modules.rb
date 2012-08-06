Dir[Rails.root.join('lib', 'modules', '{**.rb}')].each do |m|
  require m
end
