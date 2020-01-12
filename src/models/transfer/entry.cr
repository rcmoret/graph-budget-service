require "graphql-crystal"

module Transfer
  class Entry
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "to_transaction_id")]
    getter to_transaction_id : Int32
    field :to_transaction_id

    @[JSON::Field(key: "to_transaction")]
    getter to_transaction : Transaction::Entry
    field :to_transaction

    @[JSON::Field(key: "from_transaction_id")]
    getter from_transaction_id : Int32
    field :from_transaction_id

    @[JSON::Field(key: "from_transaction")]
    getter from_transaction : Transaction::Entry
    field :from_transaction
  end
end
