# coding: utf-8
require 'mysql_double_index'

describe MysqlDoubleIndex do
  it 'db_conn' do
    r = MysqlDoubleIndex.db_double_index
    r = MysqlDoubleIndex.db_table_size("articles")
    r = MysqlDoubleIndex.db_table_size
    expect(r).to match /^test$/
  end

end
