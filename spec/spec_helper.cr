require "spec"
require "json"
require "yaml"
require "jennifer"
require "jennifer_sqlite3_adapter"
require "../src/jennifer_twin"
require "./models"

def setup_jennifer
  Jennifer::Config.configure do |conf|
    conf.logger.level = Logger::WARN
    conf.user = "anyuser"
    conf.password = "anypassword"
    conf.host = "."
    conf.adapter = "sqlite3"
    conf.db = "test.db"
    conf.verbose_migrations = false
  end
end

Spec.before_each do
  setup_jennifer
  Jennifer::Adapter.adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.adapter.rollback_transaction
end

setup_jennifer
