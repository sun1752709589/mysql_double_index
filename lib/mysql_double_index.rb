require "mysql_double_index/version"
require "mysql_double_index/db_conn"
require 'active_record'
require 'rails'
require 'terminal-table'

module MysqlDoubleIndex

  module_function
  def test
  end

  def db_double_index(table = nil)
    begin
      MysqlDoubleIndex.db_connection #连接数据库
      result = {}
      double_index = []
      redundancy_index = []
      if table.nil?
        sql="show tables"
        tables=ActiveRecord::Base.connection.execute(sql)
      else
        tables = []
        tables << [table]
      end
      tables.each do |item|
        tmp_hash = {}
        keys = ActiveRecord::Base.connection.execute("show index from #{item[0]}")
        keys.each do |item|
          tmp_hash["#{item[2]}"] = {} if tmp_hash["#{item[2]}"].nil?
          item[4] += "(#{item[7]})" if !item[7].nil?
          if tmp_hash["#{item[2]}"]['columns'].nil?
            tmp_hash["#{item[2]}"]['columns'] = [item[4]]
          else
            tmp_hash["#{item[2]}"]['columns'] << item[4]
          end
          tmp_hash["#{item[2]}"]['index_type'] = item[10]
        end
        result.merge!({item[0] => tmp_hash})
      end
      result.each do |table,indexs|
        handled_index = []
        indexs.each do |index_name_outer,index_columns_outer|
          indexs.each do |index_name_inner,index_columns_inner|
            next if index_name_inner == index_name_outer || index_columns_inner['index_type'] != index_columns_outer['index_type'] || handled_index.include?(index_name_inner.to_s + index_name_outer.to_s) || handled_index.include?(index_name_outer.to_s + index_name_inner.to_s)
            #重复索引
            if get_index_columns_sorted(index_columns_inner['columns']) == get_index_columns_sorted(index_columns_outer['columns'])
              double_index << "#{table}上存在重复的索引:【#{index_name_outer.to_s + get_index_columns_sorted(index_columns_outer['columns'],true)}】&【#{index_name_inner.to_s + get_index_columns_sorted(index_columns_inner['columns'],true)}】"
            elsif has_redundancy_index?(index_columns_inner['columns'],index_columns_outer['columns'])
              #冗余索引
              redundancy_index << "#{table}上存在冗余的索引:【#{index_name_outer.to_s + get_index_columns_sorted(index_columns_outer['columns'],true)}】&【#{index_name_inner.to_s + get_index_columns_sorted(index_columns_inner['columns'],true)}】"
            end
            handled_index << index_name_inner.to_s + index_name_outer.to_s
          end
        end
        handled_index = []
      end
      print_arr = []
      double_index.each do |item|
        print_arr << [item]
      end
      table = Terminal::Table.new :title => "重复索引", :rows => print_arr
      puts table if double_index.size > 0
      if double_index.size < 1
        table = Terminal::Table.new :title => "暂无检索到重复索引"
        puts table
      end

      print_arr = []
      redundancy_index.each do |item|
        print_arr << [item]
      end
      table = Terminal::Table.new :title => "冗余索引", :rows => print_arr
      puts table if redundancy_index.size > 0
      if redundancy_index.size < 1
        table = Terminal::Table.new :title => "暂无检索到冗余索引"
        puts table
      end
    rescue Exception => e
      puts e.backtrace
    ensure
      MysqlDoubleIndex.db_close #释放链接
    end
  end

  def db_table_size(table = nil)
    begin
      MysqlDoubleIndex.db_connection #连接数据库
      print_arr = []
      sql = "select database()"
      database = ActiveRecord::Base.connection.execute(sql).first[0]
      sql="use information_schema"
      ActiveRecord::Base.connection.execute(sql)
      if table.nil?
        sql = "select TABLE_NAME,ENGINE,TABLE_ROWS,AVG_ROW_LENGTH,DATA_LENGTH,INDEX_LENGTH,(DATA_LENGTH+INDEX_LENGTH) as TABLE_LENGTH,CREATE_TIME from information_schema.tables where table_schema = '#{database}'"
      else
        sql = "select TABLE_NAME,ENGINE,TABLE_ROWS,AVG_ROW_LENGTH,DATA_LENGTH,INDEX_LENGTH,(DATA_LENGTH+INDEX_LENGTH) as TABLE_LENGTH,CREATE_TIME from information_schema.tables where table_schema = '#{database}' and table_name = '#{table}'"
      end
      tables = ActiveRecord::Base.connection.execute(sql)
      head = ["table name","engine","table rows","average row length","data length","index length","sum lemgth","create time"]
      tables.each do |item|
        item.each_with_index do |data,index|
          if [4,5,6].include?(index)
            item[index] = byte2mb(data)
          end
          if 7 == index
            item[index] = item[index].to_s[0...20]
          end
        end
        print_arr << item
      end
      table = Terminal::Table.new :title => "表占用磁盘详情", :headings => head, :rows => print_arr
      puts table
    rescue Exception => e
    ensure
      sql="use #{database}"
      ActiveRecord::Base.connection.execute(sql)
      MysqlDoubleIndex.db_close #释放链接
    end
  end

  #change byte to MB
  def byte2mb(byte)
    byte = byte.to_f
    if byte < 1024
      return "#{byte}Byte"
    elsif byte/1024 < 1024
      return "#{(byte/1024).round(2)}KB"
    elsif byte/(1024**2) < 1024
      return "#{(byte/(1024**2)).round(2)}MB"
    elsif byte/(1024**3) < 1024
      return "#{(byte/(1024**3)).round(2)}GB"
    elsif byte/(1024**4) < 1024
      return "#{(byte/(1024**4)).round(2)}TB"
    end
  end

  def get_index_columns_sorted(columns, sub_part = false)
    if sub_part
      '(' + columns.join(',') + ')'
    else
      '(' + columns.map do |item|
        if item.include?('(')
          item[0...item.index('(')]
        else
          item
        end
       end.join(',') + ')'
    end
  end
  def get_index_columns_join(columns)
    columns.map do |item|
      if item.include?('(')
        item[0...item.index('(')]
      else
        item
      end
     end.join(',')
  end
  def has_redundancy_index?(columns1, columns2)
    columns1 = columns1.map do |item|
      if item.include?('(')
        item[0...item.index('(')]
      else
        item
      end
    end
    columns2 = columns2.map do |item|
      if item.include?('(')
        item[0...item.index('(')]
      else
        item
      end
    end
    if columns1.size > columns2.size
      columns1,columns2 = columns2,columns1
    end
    columns1.each_with_index do |item,index|
      return false if item != columns2[index]
    end
    return true
  end
end
