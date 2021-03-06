ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "capybara/rails"
require "active_support/testing/setup_and_teardown"
require 'factories'
require 'webmock/minitest'
require 'http_stubs'

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods

  before { DatabaseCleaner.start }
  after  { DatabaseCleaner.clean }
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  register_spec_type(/integration$/, self)

  after do
    Capybara.reset_sessions!
  end


  before do
    HTTPMocks::stub_octocat
  end

  def login_with_oauth
    visit "/auth/github"
  end
end

#class APITest < ActionDispatch::IntegrationTest

  #register_spec_type /API$/, self
#end

Capybara.default_host = "http://ngmodules.org"

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end

Turn.config.format = :outline

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:github, {
  uid:  '12345',
  nickname: 'octocat',

  info: {
    nickname: 'octocat',
    name: 'Octocat McGithub',
    email: 'octocat@github.com'
  }

})
