def setup_jennifer
  Jennifer::Config.configure do |conf|
    # conf.logger.level = Logger::WARN
    conf.user = "anyuser"
    conf.password = "anypassword"
    conf.host = "."
    conf.adapter = "sqlite3"
    conf.db = "test.db"
    conf.verbose_migrations = false
  end
end

setup_jennifer
