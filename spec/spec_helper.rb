require 'fakeweb'
require 'pry'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each {|f| require f}
require 'httparty_dude'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}")).read
end

RSpec.configure do |config|
  config.include HTTPartyDude::StubResponse

  config.before(:suite) do
    FakeWeb.allow_net_connect = false
  end

  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end  
end