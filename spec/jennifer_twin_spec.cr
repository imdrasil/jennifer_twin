require "./spec_helper"

class AllFieldsUserTwin
  include JenniferTwin
  include JSON::Serializable

  map_fields User
end

class RenamedFieldUserTwin
  include JenniferTwin
  include JSON::Serializable

  map_fields(User, {
    name: { key: :first_name }
  })

  @[JSON::Field(key: :oid, emit_null: true)]
  @id : Int32?
end

class IgnoredFieldUserTwin
  include JenniferTwin

  map_fields(User, {
    age: { ignore: true }
  })
end

class CustomConstructorUserTwin
  include JenniferTwin

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
        puts user_twin.inspect
      end
    end

    context "with custom key" do
      it "maps all fields" do
        user = User.generate
        user_twin = RenamedFieldUserTwin.new(user)
        puts user_twin.inspect
      end
    end

    context "with ignore" do
      it "maps all fields" do
        user = User.generate
        user_twin = IgnoredFieldUserTwin.new(user)
        puts user_twin.inspect
      end
    end

    context "with custom constructor" do
      it "maps all fields" do
        user = User.generate
        user_twin = CustomConstructorUserTwin.new(user)
        puts user_twin.inspect
      end
    end
  end

  describe "#to_model" do
    # context "with no options" do
    #   it "maps all fields" do
    #     user = User.generate
    #     user_twin = AllFieldsUserTwin.new(user)
    #     puts user_twin.inspect
    #   end
    # end

    context "with custom key" do
      it "maps all fields" do
        user_twin = RenamedFieldUserTwin.new(User.generate)
        user = user_twin.to_model
        puts user.inspect
      end
    end

    # context "with ignore" do
    #   it "maps all fields" do
    #     user = User.generate
    #     user_twin = IgnoredFieldUserTwin.new(user)
    #     puts user_twin.inspect
    #   end
    # end
  end

  describe "JSON annotations" do
    context "without additional annotations" do
      it "maps all fields" do
        user = User.generate
        user_twin = AllFieldsUserTwin.new(user)
        puts user_twin.to_json
      end
    end

    context "with additional annotation" do
      it "maps all fields" do
        user = User.generate
        user_twin = RenamedFieldUserTwin.new(user)
        puts user_twin.to_json
        puts user_twin.inspect
      end
    end
  end

  describe "YAML annotations" do

  end
end
