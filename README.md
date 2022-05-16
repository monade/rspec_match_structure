# RSpec match_structure

[![Ruby Gem](https://github.com/monade/rspec_match_structure/actions/workflows/gem-push.yml/badge.svg)](https://github.com/monade/rspec_match_structure/actions/workflows/gem-push.yml)

Raise your expectations! RSpec match_structure is a gem that allows to test the structure of your string, hashes and lists.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_match_structure'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec_match_structure

## Usage

`match_strucure` can match various types of data and structures against schemas. A dead simple example of what it can do is:

```ruby
expect(["a", "b", "c"]).to match_structure(a_list_of(String).with(2).elements_at_least)
```

Another example:

```ruby
expect([
         {
           id: '1',
           type: 'users'
         },
         {
           id: '2',
           type: 'users'
         },
         {
           id: '1',
           type: 'posts'
         }
       ]).to match_structure(a_list_with({ type: 'users' }).exactly(2).times)
```

It can also match string agains regular expressions:

```ruby
 expect("abc").to match_structure( /abc/ )
```

This is especially useful when you want to test a JSON:API response:

```ruby

    expect(response.body).to match_structure(
                               {
                                 data: {
                                     id: String,
                                     type: 'someType',
                                     attributes: {
                                       anAttribute: String
                                     }
                                },
                                 included: [
                                   a_list_with({ type: 'relatedType' }).exactly(1).times
                                 ]
                               }
                             )
```

To see all the various features please refer to the [spec file](https://github.com/monade/rspec_match_structure/blob/master/spec/rspec_match_structure_spec.rb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/monade/rspec_match_structure.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
