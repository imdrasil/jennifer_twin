module JenniferTwin
  VERSION = "0.1.0"

  macro map_fields(klass, options = {} of Nil => Nil)
    {% metadata = klass.resolve.constant("COLUMNS_METADATA") %}
    {% for field, opts in metadata %}
      {% if !(options[field] && options[field][:ignore] == true) %}
        {% field_name = (options[field] ? options[field][:key] : nil) || field %}
        @{{field_name.id}} : {{opts[:parsed_type].id}}
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
