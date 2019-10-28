require "graphql-crystal"

module Transaction
  class Entry
    include JSON::Serializable
    include GraphQL::ObjectType

    def self.for(account_id, month, year) : Array(Entry)
      query = "year=#{year}&month=#{month}"
      response = Rest::Client.get("accounts/#{account_id}/transactions?#{query}")
      Array(Entry).from_json(response.body)
    end

    def self.find(account_id, id) : Entry
      response = Rest::Client.get("accounts/#{account_id}/transactions/#{id}")
      from_json(response.body)
    end

    def to_s
      "hello world"
    end

    @[JSON::Field(key: "id")]
    getter id : Int32
    field :id

    @[JSON::Field(key: "account_id")]
    getter account_id : Int32
    field :accountId { account_id }

    @[JSON::Field(key: "description")]
    getter description : String?

    field :description do
      if primary_transaction_id.is_a?(Nil)
        description
      else
        parent_record.description
      end
    end

    @[JSON::Field(key: "clearance_date")]
    getter clearance_date : String?
    field :clearanceDate { clearance_date }

    @[JSON::Field(key: "account_name")]
    getter account_name : String
    field :accountName { account_name }

    @[JSON::Field(key: "check_number")]
    getter check_number : String?
    field :checkNumber { check_number }

    @[JSON::Field(key: "notes")]
    getter notes : String?
    field :notes

    @[JSON::Field(key: "budget_exclusion")]
    getter budget_exclusion : Bool
    field :budgetExclusion { budget_exclusion }

    @[JSON::Field(key: "primary_transaction_id", emit_null: true)]
    getter primary_transaction_id : Int32?
    field :primaryTransactionId { primary_transaction_id }

    # details
    @[JSON::Field(key: "amount")]
    getter amount : Int32

    @[JSON::Field(key: "budget_item_id")]
    getter budget_item_id : Int32?

    @[JSON::Field(key: "budget_category")]
    getter budget_category : String?

    @[JSON::Field(key: "icon_class_name")]
    getter icon_class_name : String?

    @[JSON::Field(key: "subtransactions")]
    getter subtransactions : Array(Subtransaction) | Nil

    private def details : Array(Detail)
      if subtransactions == nil || subtransactions.as(Array).size == 0
        [detail]
      else
        subtransactions.as(Array).map(&.as_detail)
      end
    end
    field :details

    private def parent_record
      self.class.find(account_id, primary_transaction_id)
    end

    private def detail : Detail
      Detail.new({
        "amount" => amount,
        "budget_item_id" => budget_item_id,
        "budget_category" => budget_category,
        "primary_transaction_id" => primary_transaction_id,
        "icon_class_name" => icon_class_name
      })
    end
  end

  class Subtransaction
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    getter id : Int32

    @[JSON::Field(key: "amount")]
    getter amount : Int32

    @[JSON::Field(key: "budget_item_id")]
    getter budget_item_id : Int32?

    @[JSON::Field(key: "budget_category")]
    getter budget_category : String?

    @[JSON::Field(key: "icon_class_name")]
    getter icon_class_name : String?

    @[JSON::Field(key: "primary_transaction_id")]
    getter primary_transaction_id : Int32

    def as_detail : Detail
      Detail.new({
        "amount" => amount,
        "budget_item_id" => budget_item_id,
        "budget_category" => budget_category,
        "primary_transaction_id" => primary_transaction_id,
        "icon_class_name" => icon_class_name
      })
    end
  end

  class Detail
    include GraphQL::ObjectType
    getter data

    def initialize(data : Hash(String, Int32 | String | Nil))
      @data = data
    end

    field :amount { data["amount"] }
    field :budgetItemId { data["budget_item_id"] }
    field :budgetCategory { data["budget_category"] }
    field :iconClassName { data["icon_class_name"] }
    field :primaryTransactionId { data["primary_transaction_id"] }
  end
end
