# Become Account feature for Rodauth

This Rodauth feature allows you to easily switch into another Rodauth account,
without requiring that specific accounts password.

A nice bonus is that it remembers your original account, so when you log out of
the temporary account, you're logged back in as you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rodauth-become_account"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rodauth-become_account

## Usage

To use the become account feature requires two steps.

The first is to enable the feature:

```ruby
class App < Roda
  plugin :rodauth do
    enable :become_account
  end
end
```

And the second is to setup a route to become an account:

```ruby
class App < Roda
  plugin :rodauth do
    enable :become_account
  end

  route do |r|
    r.is "become", :id do |id|
      # Authenticate the request to allow this action.
      #
      # Can be done multiple ways. For this example, we're just going to allow
      # all become_account actions if running in development mode.
      #
      # You want to ensure you protect this route somehow.
      if ENV["RACK_ENV"] != "development"
        r.halt([401, { "Content-Type" => "text/html" }, ["Access denied"]])
      end

      # Perform your account lookup.
      account = DB[:accounts][id: id.to_i]

      # Optional.
      flash[:notice] = "You've successfully became #{account[:email]}"

      # Switch accounts using the become_account feature.
      rodauth.become_account(account)
    end
  end
end
```

## Edgecases

It's possible that 2-factor authentication will cause issues becoming users who
have that feature enabled. If you experience that issue, open a discussion so
we can possibly work around it.

## Where's my routes?

Most of Rodauth's features enable routes by default, allowing you to get up and
running immediately. I wanted to do that with this feature, but I didn't want to
risk exposing a feature to become any-account without any forethought.

So with that said, you need to implement your own route that allows an account
to become another account.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adam12/rodauth-become_account.

I love pull requests! If you fork this project and modify it, please ping me to see
if your changes can be incorporated back into this project.

That said, if your feature idea is nontrivial, you should probably open an issue to
[discuss it](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)
before attempting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
