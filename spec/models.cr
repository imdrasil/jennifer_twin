abstract class Model < Jennifer::Model::Base
  with_timestamps
end

class User < Model
  mapping(
    id: Primary32,
    name: String,
    age: Int32?,
    admin: { type: Bool, default: false },
    created_at: Time?,
    updated_at: Time?
  )

  has_many :posts, Post

  @@global_index = 0

  def self.generate_list(count)
    count.times.map { |i| create!({name: "User #{i}", age: i}) }.to_a
  end

  def self.generate
    @@global_index += 1
    new({name: "User #{@@global_index}", age: @@global_index}).tap do |instance|
      instance.created_at = instance.updated_at = Time.utc
    end
  end
end

class Post < Model
  mapping(
    id: Primary32,
    title: String,
    text: String,
    user_id: Int32?,
    rating: { type: Float64, default: 0.0 },
    created_at: Time?,
    updated_at: Time?
  )

  belongs_to :user, User

  def self.generate_list(count)
    count.times.map { |i| create!({title: "Post #{i}", text: "Text #{i}"}) }.to_a
  end
end
