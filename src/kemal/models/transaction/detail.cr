require "graphql-crystal"

module Transaction
  class Detail
    include GraphQL::ObjectType
    getter data

    def initialize(data : Hash(String, String | Int32 | Bool | Nil))
      @data = data
    end

    field :description { data["description"] }
    field :amount { data["amount"] }
    field :budgetCategory { data["budget_category"] }
    field :budgetItemId { data["budget_item_id"] }
    field :iconClassName { data["icon_class_name"] }
    field :primaryTransactionId { data["primary_transaction_id"] }
  end
end
