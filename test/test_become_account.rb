require "minitest/autorun"
require "rack/test"
require "roda"

class TestBecomeAccount < Minitest::Test
  include Rack::Test::Methods

  def app
    Class.new(Roda) do
      plugin :rodauth do
        enable :become_account
      end
    end
  end

  def test_logout_sets_previous_session
    get "/login"
  end
end
