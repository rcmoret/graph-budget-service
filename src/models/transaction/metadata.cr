require "graphql-crystal"

module Transaction
  class Metadata
    include GraphQL::ObjectType
    include JSON::Serializable

    def self.for(account_id : Int32, month : Int32, year : Int32) : Metadata
      query = "month=#{month}&year=#{year}"
      response = Rest::Client.get("accounts/#{account_id}/transactions/metadata?#{query}")
      from_json(response.body)
    end

    @[JSON::Field(key: "prior_balance")]
    getter prior_balance : Int32
    field :prior_balance

    @[JSON::Field(key: "date_range")]
    getter date_range : Array(String)
    field :date_range

    @[JSON::Field(key: "query_options")]
    getter query_options : QueryOptions

    field :account_id { query_options.account_id.as(String).to_i }
    field :month { query_options.month.as(String).to_i }
    field :year { query_options.year.as(String).to_i }
    field :include_pending { query_options.include_pending }
  end

  class QueryOptions
    include JSON::Serializable

    @[JSON::Field(key: "account_id")]
    getter account_id : Int32 | String

    @[JSON::Field(key: "include_pending")]
    getter include_pending : Bool

    @[JSON::Field(key: "month")]
    getter month : Int32 | String

    @[JSON::Field(key: "year")]
    getter year : Int32 | String
  end
end
