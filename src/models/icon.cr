require "graphql-crystal"

class Icon
  include GraphQL::ObjectType
  include JSON::Serializable

  def self.all : Array(Icon)
    response = Rest::Client.get("icons")
    Array(self).from_json(response.body)
  end

  def self.find(id) : Icon
    response = Rest::Client.get("icons/#{id}")
    from_json(response.body)
  end

  @[JSON::Field(key: "id")]
  getter id : Int32
  field :id

  @[JSON::Field(key: "class_name")]
  getter class_name : String
  field :class_name

  @[JSON::Field(key: "name")]
  getter name : String
  field :name
end
