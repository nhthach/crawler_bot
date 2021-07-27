namespace :scheduler do
  desc "This task is called by the Heroku scheduler add-on"
  task :crawling => :environment do
    puts "Updating feed..."
    CrawlingService.new.call
    puts "done."
  end
end
