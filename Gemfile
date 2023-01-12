source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem 'active_model_serializers', '~> 0.10.13'
gem "bootsnap", require: false
gem 'jwt', '~> 2.6'
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem "rails", "~> 7.0.4"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem 'bcrypt', '~> 3.1', '>= 3.1.18'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.0', '>= 6.0.1'
  gem 'faker', '~> 3.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'timecop', '~> 0.9.6'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

