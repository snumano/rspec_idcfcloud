require 'capybara/rspec'
require 'capybara/mechanize'
require 'capybara/poltergeist'
require 'ffaker'
require 'uri'
require 'open-uri'
require 'nokogiri'

Capybara.configure do |config|
  config.app = "fake"
#  config.default_driver = :mechanize
  config.default_driver = :poltergeist
#  config.default_driver = :selenium
  config.app_host       = 'https://console.jp-east.idcfcloud.com'
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: STDERR)
end
 
RSpec.configure do |config|
  config.include Capybara::DSL
  config.order = 'random'
end

=begin
class Capybara::Mechanize::Browser < Capybara::RackTest::Browser
  def default_user_agent
#    "cucumber"
     "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:29.0) Gecko/20100101 Firefox/29.0"
  end
end
=end

