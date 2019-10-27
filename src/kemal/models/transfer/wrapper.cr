require "graphql-crystal"

module Transfer
  class Wrapper
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "metadata")]
    getter metadata : Metadata
    field :metadata

    @[JSON::Field(key: "transfers")]
    getter collection : Array(Entry)
    field :collection
  end
end
