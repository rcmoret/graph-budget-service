require "graphql-crystal"

module Transfer
  class Metadata
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "limit")]
    getter limit : Int32
    field :limit

    @[JSON::Field(key: "offset")]
    getter offset : Int32
    field :offset

    @[JSON::Field(key: "viewing")]
    getter viewing : Array(Int32)
    field :viewing

    @[JSON::Field(key: "total")]
    getter total : Int32
    field :total
  end
end
