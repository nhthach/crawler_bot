require "sidekiq/web"
Sidekiq::Extensions.enable_delay!

# Perform Sidekiq jobs immediately in Heroku review apps. Don't need to have a dyno for sidekiq
if Rails.env.production? && ENV["HEROKU_REVIEW_APP"].present?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
