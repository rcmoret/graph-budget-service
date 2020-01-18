require "graphql-crystal"

module Transaction
  class Entry
    include JSON::Serializable
    include GraphQL::ObjectType

    def self.for(account_id, month, year) : Array(Entry)
      query = "year=#{year}&month=#{month}"
      response = Rest::Client.get("accounts/#{account_id}/transactions?#{query}")
      Array(self).from_json(response.body)
    end

    def self.find(account_id, id) : Entry
      response = Rest::Client.get("accounts/#{account_id}/transactions/#{id}")
      from_json(response.body)
    end

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "account_id")]
    getter account_id : Int32
    field :account_id

    @[JSON::Field(key: "description")]
    getter description : String?
    field :description

    @[JSON::Field(key: "clearance_date")]
    getter clearance_date : String?
    field :clearance_date

    @[JSON::Field(key: "account_name")]
    getter account_name : String
    field :account_name

    @[JSON::Field(key: "check_number")]
    getter check_number : String?
    field :check_number

    @[JSON::Field(key: "notes")]
    getter notes : String?
    field :notes

    @[JSON::Field(key: "budget_exclusion")]
    getter budget_exclusion : Bool
    field :budget_exclusion

    @[JSON::Field(key: "details")]
    getter details : Array(Detail)
    field :details
  end

  class Detail
    include GraphQL::ObjectType
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "amount")]
    getter amount : Int32
    field :amount

    @[JSON::Field(key: "budget_item_id")]
    getter budget_item_id : Int32?
    field :budget_item_id

    @[JSON::Field(key: "budget_category")]
    getter budget_category : String?
    field :budget_category

    @[JSON::Field(key: "icon_class_name")]
    getter icon_class_name : String?
    field :icon_class_name
  end
end
