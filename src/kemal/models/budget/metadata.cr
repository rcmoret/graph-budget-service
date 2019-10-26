require "graphql-crystal"

module Budget
  class Metadata
    include GraphQL::ObjectType
    include JSON::Serializable

    def self.for(month, year)
      response = Rest::Client.get("budget/items/metadata?year=#{year}&month=#{month}")
      from_json(response.body)
    end

    @[JSON::Field(key: "month")]
    getter month : Int32
    field :month

    @[JSON::Field(key: "year")]
    getter year : Int32
    field :year

    @[JSON::Field(key: "is_set_up")]
    getter is_set_up : Bool
    field :isSetUp { is_set_up }

    @[JSON::Field(key: "is_closed_out")]
    getter is_closed_out : Bool
    field :isClosedOut { is_closed_out }

    @[JSON::Field(key: "days_remaining")]
    getter days_remaining : Int32
    field :daysRemaining { days_remaining }

    @[JSON::Field(key: "spent")]
    getter spent : Int32
    field :spent
  end
end
