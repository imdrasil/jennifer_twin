# Allows to dump and load Jennifer model attributes to plain class. This allows to add any king of annotations,
# renaming, avoid callbacks and validations.
#
# ```
# class UserTwin
#   include JenniferTwin
#   include JSON::Serializable
#
#   map_fields(User, {
#     id: { annotations: [@[JSON::Field(emit_null: true)]] }
#     name: { key: :full_name },
#     password_hash: { ignore: true }
#   })
#
#   setter full_name
# end
# ```
module JenniferTwin
  VERSION = "0.1.1"

  # Returns a new instance of model class created from current twin state.
  #
  # ```
  # user = User.all.first
  # user_twin.full_name = "New Name"
  # user_twin.to_modal # <User:0x000000000030 id: nil, name: "New Name">
  # ```
  abstract def to_model

  # Creates constructor and declare getters for all fields from parent modal *klass* except those specified
  # to be ignored.
  #
  # Arguments:
  # * *klass* - class literal to be used as a related model class
  # * *options* - field specific options; by default model field is mapped to the one with same name and type;
  # supported options:
  #   * *key* - new field name
  #   * *ignore* - mark field to be ignored
  #   * *annotations* - array of annotations to be added above setter declaration
  # * *block* - given block is appended to the constructor; `record` variable can be used to get model instance.
  macro map_fields(klass, options = {} of Nil => Nil)
    {% metadata = klass.resolve.constant("COLUMNS_METADATA") %}
    {% for field, opts in metadata %}
      {% if !(options[field] && options[field][:ignore] == true) %}
        {% field_name = (options[field] ? options[field][:key] : nil) || field %}
        {{options[field] && options[field][:annotations] ? options[field][:annotations].join("\n").id : ""}}
        getter {{field_name.id}} : {{opts[:parsed_type].id}}
      {% end %}
    {% end %}


    def initialize(record : {{klass}})
      {% for field, opts in metadata %}
        {% if !(options[field] && options[field][:ignore] == true) %}
          {% field_name = (options[field] ? options[field][:key] : nil) || field %}
          @{{field_name.id}} = record.{{field.id}}
        {% end %}
      {% end %}
      {{yield}}
    end

    def to_model : {{klass}}
      {{klass}}.new({
        {% for field, opts in metadata %}
          {% if !(options[field] && options[field][:ignore] == true) %}
            {% field_name = (options[field] ? options[field][:key] : nil) || field %}
            {{field.id}}: @{{field_name.id}},
          {% end %}
        {% end %}
      })
    end
  end
end
