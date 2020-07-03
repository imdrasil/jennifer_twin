require "./spec_helper"

class AllFieldsUserTwin
  include JenniferTwin
  include JSON::Serializable
  include YAML::Serializable

  map_fields User
end

class RenamedFieldUserTwin
  include JenniferTwin
  include JSON::Serializable
  include YAML::Serializable

  map_fields(User, {
    name: { key: :first_name },
    id: { annotations: [
      @[JSON::Field(key: :oid, emit_null: true)],
      @[YAML::Field(key: :oid, emit_null: true)]
    ]}
  })
end

class IgnoredFieldUserTwin
  include JenniferTwin

  map_fields(User, {
    age: { ignore: true }
  })
end

class CustomConstructorUserTwin
  include JenniferTwin

  getter full_name

  map_fields(User) do
    @full_name = "#{record.name} Snow"
  end
end

describe JenniferTwin do
  describe ".map" do
    context "with no options" do
      it "maps all fields" do
        user = User.generate
        user_twin = AllFieldsUserTwin.new(user)
        {% for method in %i(id name age admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
      end
    end

    context "with custom key" do
      it "maps all fields" do
        user = User.generate
        user_twin = RenamedFieldUserTwin.new(user)
        {% for method in %i(id age admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
        user_twin.first_name.should eq(user.name)
      end
    end

    context "with ignore" do
      it "maps all fields" do
        user = User.generate
        user_twin = IgnoredFieldUserTwin.new(user)
        {% for method in %i(id name admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
        user_twin.inspect.should_not match(/@age/)
      end
    end

    context "with custom constructor" do
      it "maps all fields" do
        user = User.generate
        user_twin = CustomConstructorUserTwin.new(user)
        {% for method in %i(id name age admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
        user_twin.full_name.should eq("#{user.name} Snow")
      end
    end
  end

  describe "#to_model" do
    context "with no options" do
      it "maps all fields" do
        user_twin = AllFieldsUserTwin.new(User.generate)
        user = user_twin.to_model
        {% for method in %i(id name age admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
      end
    end

    context "with custom key" do
      it "maps all fields" do
        user_twin = RenamedFieldUserTwin.new(User.generate)
        user = user_twin.to_model
        {% for method in %i(id age admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
        user_twin.first_name.should eq(user.name)
      end
    end

    context "with ignore" do
      it "maps all fields" do
        user_twin = IgnoredFieldUserTwin.new(User.generate)
        user = user_twin.to_model
        {% for method in %i(id name admin created_at updated_at) %}
          user_twin.{{method.id}}.should eq(user.{{method.id}})
        {% end %}
        user.age.should be_nil
      end
    end
  end

  describe "JSON annotations" do
    context "without additional annotations" do
      it "maps all fields" do
        user = User.generate
        user_twin = AllFieldsUserTwin.new(user)
        user_twin.to_json.should eq({
          # id: user.id,
          name: user.name,
          age: user.age,
          admin: user.admin?,
          created_at: user.created_at,
          updated_at: user.updated_at
        }.to_json)
      end
    end

    context "with additional annotation" do
      it "maps all fields" do
        user = User.generate
        user_twin = RenamedFieldUserTwin.new(user)
        user_twin.to_json.should eq({
          oid: user.id,
          first_name: user.name,
          age: user.age,
          admin: user.admin?,
          created_at: user.created_at,
          updated_at: user.updated_at
        }.to_json)
      end
    end
  end

  describe "YAML annotations" do
    context "without additional annotations" do
      it "maps all fields" do
        user = User.generate
        user_twin = AllFieldsUserTwin.new(user)
        user_twin.to_yaml.should eq({
          # id: user.id,
          name: user.name,
          age: user.age,
          admin: user.admin?,
          created_at: user.created_at,
          updated_at: user.updated_at
        }.to_yaml)
      end
    end

    context "with additional annotation" do
      it "maps all fields" do
        user = User.generate
        user_twin = RenamedFieldUserTwin.new(user)
        user_twin.to_yaml.should eq({
          oid: user.id,
          first_name: user.name,
          age: user.age,
          admin: user.admin?,
          created_at: user.created_at,
          updated_at: user.updated_at
        }.to_yaml)
      end
    end
  end
end
