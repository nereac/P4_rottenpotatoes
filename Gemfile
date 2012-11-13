source 'https://rubygems.org'

gem 'ruby-tmdb3'
gem 'omniauth-twitter'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


group :development, :test do
  gem 'simplecov'
  gem 'sqlite3'
  gem 'debugger'
  gem 'fakeweb'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'haml'


group :test do
  gem 'rspec-rails'
  gem 'ZenTest' # autotest
  gem 'rspec-expectations'
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels' # some pre-fabbed step definitions  
  gem 'database_cleaner' # to clear Cucumber's test database between runs
  gem 'capybara'         # lets Cucumber pretend to be a web browser
  gem 'launchy'          # a useful debugging aid for user stories
  gem 'simplecov', :require => false
end
