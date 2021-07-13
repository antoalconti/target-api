source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'activeadmin', '~> 2.6'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise', '~> 4.7', '>= 4.7.1'
gem 'devise_token_auth', '~> 1.1', '>= 1.1.3'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'geokit-rails', '~> 2.3', '>= 2.3.1'
gem 'jbuilder', '~> 2.9', '>= 2.9.1'
gem 'redis', '~> 4.1', '>= 4.1.3'
gem 'sidekiq', '~> 6.0', '>= 6.0.4'
gem 'sidekiq-cron', '~> 1.1'

group :test do
  gem 'action-cable-testing', '~> 0.3.1'
  gem 'addressable', '~> 2.8'
  gem 'rspec-json_expectations', '~> 2.2'
  gem 'rspec-sidekiq', '~> 3.0.1'
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker', '~> 2.0'
  gem 'rspec-rails'
  gem 'rubocop-rails', '~> 2.3', '>= 2.3.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
