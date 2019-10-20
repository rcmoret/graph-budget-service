require "graphql-crystal"
require "../rest_client"

class Account
  include GraphQL::ObjectType

  def self.all
    response = Rest::Client.get("accounts")
    Array(self).from_json(response.body)
  end

  JSON.mapping(
    id: Int32,
    name: String,
    cash_flow: Bool,
    balance: Int32,
    priority: Int32
  )

  field :id
  field :name
  field :balance
  field :priority
  field :cashFlow do
    cash_flow
  end
end
