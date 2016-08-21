# Newsfeeder

## Usage
__Please note:__
- Before running the app, Redis should be installed and running.
- When `Newsfeeder` class is initited, by default all the arguments has defaults unless you chose to overwrite the them, the arguments are `redis` Redis object , `http_folder_url` remote http folder url, `news_list_name` name of the news list in Redis, there default values are as follow:
  - redis = Redis.new
  - http_folder_url = 'http://feed.omgili.com/5Rh5AMTrc4Pv/mainstream/posts/'
  - news_list_name = 'NEWS_XML'

You only need to run `Newsfeeder::Newsfeeder.new` if you chose to change the defaults, it would look something like:
```
  Newsfeeder::Newsfeeder.new(
    redis: Redis.new(:host => "10.0.1.1", :port => 6380, :db => 15),
    http_folder_url: 'http://some_other_http_folder_url',
    news_list_name: 'some_other_list_name'
  )
```

__Only needs to be done once:__
- `$ git clone git@github.com:karimmtarek/newsfeeder.git`
- `$ bin/setup`

__Thereafter:__
- `$ bin/console`
- `$ newsfeeder = Newsfeeder::Newsfeeder.new`
- `$ newsfeeder.redis_feeder(items: :all)` or `$ newsfeeder.redis_feeder(items: 10)` if you just want limited number of zip files to be downloaded and feed into Redis.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/newsfeeder.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

