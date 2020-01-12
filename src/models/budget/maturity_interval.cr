module Budget
  class MaturityInterval
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "category_id")]
    getter category_id : Int32
    field :category_id

    @[JSON::Field(key: "month")]
    getter month : Int32
    field :month

    @[JSON::Field(key: "year")]
    getter year : Int32
    field :year
  end
end
