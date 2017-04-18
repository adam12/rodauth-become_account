# frozen_string_literal: true
module Rodauth
  Feature.define(:become_account) do
    depends :login, :logout

    auth_value_method :previous_session_key, :previous_account_id

    def logout_redirect
      return login_redirect if session[session_key]

      super
    end

    def become_account(account)
      session[previous_session_key] = session[session_key]
      account_from_login(account[login_column])
      update_session
    end

    def update_session
      previous_session_value = session[previous_session_key]

      super

      session[previous_session_key] = previous_session_value if previous_session_value
    end

    def clear_session
      previous_session_value = session[previous_session_key]

      super

      session[session_key] = previous_session_value if previous_session_value
    end
  end
end
