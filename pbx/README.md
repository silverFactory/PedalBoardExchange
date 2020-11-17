# PedalBoardExchange

This app is designed to make buying and selling guitar effects pedals on Craigslist easier. The command line interface asks the user to search for a specific pedal, finds relevant posts on Craigslist, then uses the information from those posts to search Guitar Center's website to get the new price as well as the manufacturer's description.

[Issues]
-currently this app is set up to search specifically the New York area. Because Craigslist breaks up regions of the country differently, usually metropolitan areas have their own Craigslist, but then suburban and rural areas it's a bit all over the place in terms of naming conventions. Instead of asking the user to input a zip code I just let the default search area be mine (New York). To search a different area the user would just need to go to the Craigslist themselves to find the proper region to search under, and use that region name as an optional argument for #scrape_search in pbx.rb on line 15

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pbx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pbx

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/'remarkable-middleware-5891'/pbx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
