# MysqlDoubleIndex

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/mysql_double_index`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Doc
冗余和重复索引的概念：

MySQL允许在相同列上创建多个索引，无论是有意的还是无意的。MySQL需要单独维护重复的索引，并且优化器在优化查询的时候也需要逐个地进行考虑，这会影响性能。

重复索引：是指在相同的列上按照相同的顺序创建的相同类型的索引。应该避免这样创建重复索引，发现后也应该立即移除。

冗余索引：冗余索引和重复索引有一些不同，如果创建了索引(A,B)，再创建索引(A)就是冗余索引，因为这只是前一个索引的前缀索引。因此索引(A,B)也可以当索引(A)来使用(这种冗余只是对B-Tree索引来说)。冗余索引通常发生在为表添加新索引的时候。例如，有人可能会增加一个新的索引(A,B)而不是扩展已有的索引(A)。还有一种情况是将一个索引扩展为(A,ID)，其中ID是主键，对于InnoDB来说主键列已经包含在二级索引中了，索引也是冗余的。

大多数的情况下都不需要冗余索引，应该尽量扩展已有的索引而不是创建新索引。但也有时候出于性能方面的考虑需要冗余索引，因为扩展已有的索引会导致其变得太大，从而影响其它使用该索引的查询的性能。

## Installation

Add this line to your application's Gemfile:

```ruby

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
