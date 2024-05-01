require "minitest/autorun"
require "rack/test"
require "roda"
require "sequel"
require "capybara/minitest"

if RUBY_PLATFORM =~ /java/
  DB = Sequel.connect("jdbc:sqlite::memory:")
else
  DB = Sequel.sqlite
end

DB.create_table(:account_statuses) do
  Integer :id, primary_key: true
  String :name, null: false, unique: true
end

DB.from(:account_statuses).import([:id, :name], [[1, "Unverified"], [2, "Verified"], [3, "Closed"]])

DB.create_table(:accounts) do
  primary_key :id, type: :Bignum
  foreign_key :status_id, :account_statuses, null: false, default: 1
  String :email, null: false
  index :email, unique: true
end

DB.create_table(:account_password_hashes) do
  foreign_key :id, :accounts, primary_key: true, type: :Bignum
  String :password_hash, null: false
end

class TestBecomeAccount < Minitest::Test
  include Rack::Test::Methods
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def app
    Class.new(Roda) do
      use Rack::Session::Cookie, :secret => ("THE-SECRET-" + "a" * 54)

      plugin :rodauth do
        enable :become_account
      end
      plugin :render, layout: { inline: "<%= yield %>" }

      route do |r|
        r.rodauth

        r.is "become", :id do |id|
          account = DB[:accounts][id: id.to_i]
          rodauth.become_account(account)
          r.redirect "/"
        end

        r.root do
          if (account = rodauth.account_from_session)
            "Current User: #{account[:email]}"
          else
            "No account"
          end
        end
      end
    end
  end

  def setup
    @user_1 = DB[:accounts].insert(email: "user_1@example.com")
    DB[:account_password_hashes].insert(id: @user_1, password_hash: "$2a$10$wxZrk9FHjW.LoRgmaFy3eO6D6Uw/UiKRRHd21264717XvIoGqKIvy")
    @user_2 = DB[:accounts].insert(email: "user_2@example.com")

    Capybara.app = app
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver

    DB[:account_password_hashes].delete
    DB[:accounts].delete
  end

  def login
    visit "/login"

    fill_in "Login", with: "user_1@example.com"
    fill_in "Password", with: "secret"

    click_button "Login"
  end

  def test_login
    login

    assert_text "Current User: user_1@example.com"
  end

  def test_becoming_user
    login

    visit "/become/#{@user_2}"

    assert_text "Current User: user_2@example.com"
  end

  def test_logout_sets_previous_session
    login
    assert_text "Current User: user_1@example.com"
    visit "/become/#{@user_2}"
    assert_text "Current User: user_2@example.com"
    visit "/logout"
    click_button "Logout"
    assert_text "Current User: user_1@example.com"
  end
end
