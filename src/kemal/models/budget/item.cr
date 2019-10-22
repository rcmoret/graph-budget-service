require "graphql-crystal"

module Budget
  class Item
    include GraphQL::ObjectType
    getter data

    def self.find(category_id, item_id) : Item
      response = Rest::Client.get("budget/categories/#{category_id}/items/#{item_id}")
      item_attrs = JSON.parse(response.body)
      from_json(item_attrs)
    end

    def self.from_json(data : JSON::Any) : Item
      attrs = Hash(String, String | Int32 | Bool | Nil).new.tap do |hash|
        hash["id"] = data["id"].as_i
        hash["amount"] = data["amount"].as_i
        hash["name"] = data["name"].to_s
        hash["expense"] = data["expense"].as_bool
        hash["monthly"] = data["monthly"].as_bool
        hash["accrual"] = data["accrual"].as_bool
        hash["month"] = data["month"].as_i
        hash["year"] = data["year"].as_i
        hash["spent"] = data["spent"].as_i
        hash["budget_category_id"] = data["budget_category_id"].as_i
        hash["icon_class_name"] = data["icon_class_name"].to_s
        hash["transaction_count"] = data["transaction_count"].as_i
        hash["maturity_month"] = data["maturity_month"].as_i?
        hash["maturity_year"] = data["maturity_year"].as_i?
      end
      new(attrs)
    end

    def initialize(data : Hash(String, String | Int32 | Bool | Nil))
      @data = data
    end

    field :id { data["id"] }
    field :amount { data["amount"] }
    field :name { data["name"].to_s }
    field :expense { data["expense"] }
    field :monthly { data["monthly"] }
    field :accrual { data["accrual"] }
    field :month { data["month"] }
    field :year { data["year"] }
    field :spent { data["spent"] }
    field :budgetCategoryId { data["budget_category_id"] }
    field :iconClassName { data["icon_class_name"].to_s }
    field :transactionCount { data["transaction_count"] }
    field :maturityMonth { data["maturity_month"] }
    field :maturityYear { data["maturity_year"] }

    def transactions
      item_attrs = {
        "icon_class_name" => data["icon_class_name"],
        "budget_category" => data["name"],
        "budget_item_id" => data["id"],
      }
      path = "budget/categories/#{data["budget_category_id"]}/items/#{data["id"]}/transactions"
      response = Rest::Client.get(path)
      JSON.parse(response.body).as_a.map do |attrs|
        Transaction::Entry.find(attrs["account_id"].as_i, attrs["id"].as_i, item_attrs)
      end
    end
    field :transactions
  end
end
