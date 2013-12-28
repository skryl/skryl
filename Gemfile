source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '~> 3.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'app'
gem 'coffee-script'
gem 'jquery-rails'
gem 'libxml-ruby'
gem 'sass'
gem 'slim'
gem 'gon', '3.0.5'
gem 'twitter'
gem 'uglifier'
gem 'whenever', :require => false
gem 'httparty'
gem 'nike', :github => "skryl/nike", branch: "v2"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'pry', :group => :development

group :development, :test do
  gem 'rspec-rails'
  gem 'sqlite3'
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'memcachier'
  gem 'dalli'
  gem 'pg'
  gem 'thin'
  gem 'newrelic_rpm'
end
