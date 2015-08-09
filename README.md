# MysqlDoubleIndex

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/mysql_double_index`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terminal-table' #ruby下类似mysql格式化输出
gem 'mysql_double_index'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mysql_double_index

## Usage

And then execute:

    $ rails c
    #查询单个表重复&冗余索引
    $ > MysqlDoubleIndex.db_double_index("articles")
    #查询所有表重复&冗余索引
    $ > MysqlDoubleIndex.db_double_index
    #查询单个表磁盘占用大小
    $ > MysqlDoubleIndex.db_table_size("articles")
    #查询所有表磁盘占用大小
    $ > MysqlDoubleIndex.db_table_size

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mysql_double_index. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
