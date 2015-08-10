module MysqlDoubleIndex
  module_function
  def load_config
    config_path = Rails.root ? File.join(Rails.root, "config", "database.yml") : './config/database.yml'
    File.open(config_path)
  end

  def db_connection
    dbconfig = YAML::load(MysqlDoubleIndex.load_config)
    ActiveRecord::Base.establish_connection(dbconfig[Rails::env.to_s])
  end
  def db_close
    if ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?
      ActiveRecord::Base.connection.close
    end
  end
end
