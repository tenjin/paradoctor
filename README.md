# Paradoctor

Rails gem to "doctor" your URL parameters for endpoints requiring sensitive data in the URL, e.g.:
- email confirmations
- reset password tokens
- invitation links

The goal is to prevent 3rd party js libs from sending this sensitive information to their servers, whereby a hacked
account in their system could lead to user impersonation in your system.

![paradoctorsIRL](https://i.ebayimg.com/images/g/KhMAAOSw1XNcT30d/s-l64.jpg)

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
- Adds `<link rel="canonical" href="https://example.com/email_confirmation_token=[FILTERED]" />`, which some js
analytics libs may use instead of `location.href`.
  - Use the `canonical_href:` method argument to specify a value other than the default, which is:
`request.base_url + request.filtered_path`
- Invokes javascript to replace the URL in the user's address bar via `history#replaceState`
  - **NOTE: This will break page reloads.**
  - This will actually update `location.href` which should prevent 3rd party js libs from sending the original URL
elsewhere.
  - Can be disabled via the method argument `replace_url: false`.

Finally, you can bypass the filtered params conditional by passing `force: true` to enact all of the above behaviors.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paradoctor.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
