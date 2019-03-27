# Paradoctor

Rails gem to "doctor" your URL parameters for endpoints requiring sensitive data in the URL, e.g.:
- email confirmations
- reset password tokens
- invitation links

The goal is to prevent 3rd party js libs from sending this sensitive information to their servers, whereby a hacked
account in their system could lead to user impersonation in your system.

![paradoctorsIRL](https://upload.wikimedia.org/wikipedia/commons/3/38/USAF_Pararescue_Flash.jpg)

## Important Note

While this gem could certainly be used as a fail-safe, a better approach to accomplish the goal is outlined here: https://thoughtbot.com/blog/is-your-site-leaking-password-reset-links

Basically, use a session + a 302 redirect to move the sensitive data out of the URL before javascript can access it.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'paradoctor'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install paradoctor
```

## Usage

Add `<%= paradoctor_tags %>` to the `<head>` section of your application layout before you load any other javascript.

The default behavior checks to see if any URL parameter values are filtered from logs according to Rails'
[filtered_parameters](https://guides.rubyonrails.org/action_controller_overview.html#parameters-filtering) setting. _If
not, this gem does nothing._ If so, however, this method:
- Adds `<meta name="referrer" content="origin" />` to try to [prevent future requests from sending the URL via the
Referer header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy).
  - Use the `referrer_content:` method argument to specify a value other than "origin"
- Adds `<link rel="canonical" href="https://example.com/email_confirmation?token=[FILTERED]" />`, which some js
analytics libs may use instead of `location.href`.
  - By default, the `href` value used will be: `request.base_url + request.filtered_path`
  - Use the `canonical_href:` method argument to specify a value other than the default.
- Invokes javascript to replace the URL in the user's address bar via `history#replaceState`
  - **NOTE: This will break page reloads.**
  - This will actually update `location.href` which should prevent 3rd party js libs from sending the original URL
elsewhere.
  - Can be disabled via the method argument `replace_url: false`.

Finally, you can bypass the filtered params conditional by passing `force: true` to enact all of the above behaviors.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/tenjin/paradoctor.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
