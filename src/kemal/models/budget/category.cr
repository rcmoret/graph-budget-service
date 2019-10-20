require "graphql-crystal"
require "http"

module Budget
  class Category
    include GraphQL::ObjectType

    def self.all
      response = Rest::Client.get("budget/categories")
      Array(self).from_json(response.body)
    end

    JSON.mapping(
      id: Int32,
      name: String,
      monthly: Bool,
      expense: Bool,
      accrual: Bool,
      default_amount: Int32,
      icon_class_name: String
    )

    field :id
    field :name
    field :monthly
    field :expense
    field :accrual
    field :defaultAmount do
      default_amount
    end
    field :iconClassName do
      icon_class_name
    end
  end

  class Categories
  end
end
