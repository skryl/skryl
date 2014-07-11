#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Dorian::Application.load_tasks

desc 'Expires everything so that pages show fresher timestamps'
task :expire => :environment do
  Rails.cache.clear
  puts "Cleared cache"
end

desc 'Update data from source for all modules (e.g. Goodreads, Twitter, etc.)'
task :update => :environment do
  DataModule.all_modules.each do |mod|
    begin
      mod.update
    rescue
      $stderr.puts "Update error: " + $!.message
    end
  end
  Rails.cache.clear
  puts "Cleared cache"
end

desc 'Iinitial update from all source modules'
task :initial_update => :environment do
  DataModule.all_modules.each do |mod|
    begin
      mod.initial_update
    rescue
      $stderr.puts "Update error: " + $!.message
    end
  end
  Rails.cache.clear
  puts "Cleared cache"
end
