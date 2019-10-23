require "json"
require "graphql-crystal"
require "../rest_client"

class Account
  include GraphQL::ObjectType
  include JSON::Serializable

  def self.all
    response = Rest::Client.get("accounts")
    Array(self).from_json(response.body)
  end

  @[JSON::Field(key: "id")]
  getter id : Int32

  @[JSON::Field(key: "name")]
  getter name : String

  @[JSON::Field(key: "balance")]
  getter balance : Int32

  @[JSON::Field(key: "priority")]
  getter priority : Int32

  @[JSON::Field(key: "cash_flow")]
  getter cash_flow : Bool

  field :id
  field :name
  field :balance
  field :priority
  field :cashFlow do
    cash_flow
  end
end
