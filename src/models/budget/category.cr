require "graphql-crystal"

module Budget
  class Category
    include GraphQL::ObjectType
    include JSON::Serializable

    def self.all
      response = Rest::Client.get("budget/categories")
      Array(self).from_json(response.body)
    end

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "name")]
    getter name : String
    field :name

    @[JSON::Field(key: "monthly")]
    getter monthly : Bool
    field :monthly

    @[JSON::Field(key: "expense")]
    getter expense : Bool
    field :expense

    @[JSON::Field(key: "accrual")]
    getter accrual : Bool
    field :accrual

    @[JSON::Field(key: "default_amount")]
    getter default_amount : Int32
    field :defaultAmount { default_amount }

    @[JSON::Field(key: "icon_class_name")]
    getter icon_class_name : String?
    field :iconClassName { icon_class_name }

    @[JSON::Field(key: "icon_id")]
    getter icon_id : Int32?
    field :iconId { icon_id }
  end
end
