require "graphql-crystal"

module Transfer
  class Metadata
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "limit")]
    getter limit : Int32
    field :limit

  end
end
