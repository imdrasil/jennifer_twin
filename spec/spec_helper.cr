require "spec"
require "json"
require "yaml"
require "jennifer"
require "jennifer_sqlite3_adapter"
require "../src/jennifer_twin"
require "./support/setup"
require "./models"

Spec.before_each do
  setup_jennifer
  Jennifer::Adapter.default_adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.default_adapter.rollback_transaction
end
