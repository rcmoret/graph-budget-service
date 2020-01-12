require "json"
require "graphql-crystal"

class Account
  include GraphQL::ObjectType
  include JSON::Serializable

  def self.all
    response = Rest::Client.get("accounts")
    Array(self).from_json(response.body)
  end

  @[JSON::Field(key: "id")]
  getter id : Int32
  field :id

  @[JSON::Field(key: "name")]
  getter name : String
  field :name

  @[JSON::Field(key: "balance")]
  getter balance : Int32
  field :balance

  @[JSON::Field(key: "priority")]
  getter priority : Int32
  field :priority

  @[JSON::Field(key: "cash_flow")]
  getter cash_flow : Bool
  field :cash_flow
end
