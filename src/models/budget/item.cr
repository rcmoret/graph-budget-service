require "graphql-crystal"

module Budget
  class Item
    include GraphQL::ObjectType
    include JSON::Serializable

    def self.find(category_id, item_id) : Item
      response = Rest::Client.get("budget/categories/#{category_id}/items/#{item_id}")
      from_json(response.body)
    end

    def self.for(month, year) : Array(Item)
      response = Rest::Client.get("budget/items?year=#{year}&month=#{month}")
      Array(Item).from_json(response.body)
    end

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "amount")]
    getter amount : Int32
    field :amount

    @[JSON::Field(key: "name")]
    getter name : String
    field :name

    @[JSON::Field(key: "expense")]
    getter expense : Bool
    field :expense

    @[JSON::Field(key: "monthly")]
    getter monthly : Bool
    field :monthly

    @[JSON::Field(key: "accrual")]
    getter accrual : Bool
    field :accrual

    @[JSON::Field(key: "month")]
    getter month : Int32
    field :month

    @[JSON::Field(key: "year")]
    getter year : Int32
    field :year

    @[JSON::Field(key: "spent")]
    getter spent : Int32
    field :spent

    @[JSON::Field(key: "budget_category_id")]
    getter budget_category_id : Int32
    field :budget_category_id

    @[JSON::Field(key: "icon_class_name")]
    getter icon_class_name : String | Nil
    field :icon_class_name

    @[JSON::Field(key: "transaction_count")]
    getter transaction_count : Int32
    field :transaction_count

    @[JSON::Field(key: "maturity_month")]
    getter maturity_month : Int32 | Nil
    field :maturity_month

    @[JSON::Field(key: "maturity_year")]
    getter maturity_year : Int32 | Nil
    field :maturity_year

    field :transactions do
      response = Rest::Client.get("budget/categories/#{budget_category_id}/items/#{id}/transactions")
      Array(Transaction::Entry).from_json(response.body)
    end
  end
end
