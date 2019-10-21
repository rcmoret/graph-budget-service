require "graphql-crystal"

module Transaction
  class Entry
    include GraphQL::ObjectType
    getter data
    getter subtransactions

    def self.find(account_id : Int32, transaction_id : Int32, data : Hash(String, Int32 | String | Bool | Nil)) : Entry
      url = "accounts/#{account_id}/transactions/#{transaction_id}"
      response = JSON.parse(Rest::Client.get(url).body)
      Factory.create({
        "id" => transaction_id,
        "clearance_date" => response["clearance_date"].as_s,
        "description" => response["description"].as_s?,
        "account_name" => response["account_name"].as_s,
        "check_number" => response["check_number"].as_s?,
        "notes" => response["notes"].as_s?,
        "budget_exclusion" => response["budget_exclusion"].as_bool,
        "amount" => response["amount"].as_i,
        "budget_category" => "from find method",
        "budget_item_id" => data["budget_item_id"],
        "icon_class_name" => data["icon_class_name"]
        # "budget_category" => response["budget_category"].as_s?,
        # "icon_class_name" => "fa fas-big-booty"
      },
        [] of Hash(String, Int32 | String | Bool | Nil))
    end

    def initialize(
      data : Hash(String, Int32 | String | Bool | Nil),
      subtransactions : Array(Hash(String, Int32 | String | Bool | Nil))
    )
      @data = data
      @subtransactions = subtransactions
    end

    def details : Array(Detail)
      return [Detail.new(data.merge({ "primary_transaction_id" => nil }))] if subtransactions.none?

      subtransactions.map do |attrs|
        Detail.new({
          "description" => data["description"],
          "amount" => attrs["amount"],
          "budget_category" => attrs["budget_category"]?,
          "budget_item_id" => attrs["budget_item_id"],
          "icon_class_name" => attrs["icon_class_name"],
          "primary_transaction_id" => attrs["primary_transaction_id"]
        })
      end
    end
    field :details

    field :id { data["id"] }
    field :clearanceDate { data["clearance_date"] }
    field :description { data["description"] }
    field :accountName { data["account_name"] }
    field :checkNumber { data["check_number"] }
    field :notes { data["notes"] }
    field :budgetExclusion { data["budget_exclusion"] }

    class Factory
      alias BASETYPES = String | Int32 | Bool | Nil

      def self.create(data : Hash(String, BASETYPES), subtransactions : Array(Hash(String, BASETYPES))) : Entry
        attrs = {
          "id" => data["id"],
          "clearance_date" => data["clearance_date"],
          "description" => data["description"],
          "account_name" => data["account_name"],
          "check_number" => data["check_number"],
          "notes" => data["notes"],
          "budget_exclusion" => data["budget_exclusion"],
          "amount" => data["amount"],
          "budget_category" => data["budget_category"],
          "budget_item_id" => data["budget_item_id"],
          "icon_class_name" => data["icon_class_name"]
        }
        Entry.new(attrs, subtransactions)
      end

      def self.create_from_json(data : JSON::Any) : Entry
        attrs = {
          "id" => data["id"].as_i,
          "clearance_date" => data["clearance_date"].as_s?,
          "description" => data["description"].as_s?,
          "account_name" => data["account_name"].as_s,
          "check_number" => data["check_number"].as_s?,
          "notes" => data["notes"].as_s?,
          "budget_exclusion" => data["budget_exclusion"].as_bool,
          "amount" => data["amount"].as_i,
          "budget_category" => data["budget_category"].as_s?,
          "budget_item_id" => data["budget_item_id"].as_i?,
          "icon_class_name" => data["icon_class_name"].as_s?
        }
        subtransactions = data["subtransactions"].as_a.map do |subtransaction|
          Hash(String, String | Int32 | Bool | Nil).new.tap do |hash|
            hash["amount"] = subtransaction["amount"].as_i
            hash["budget_category"] = subtransaction["budget_category"].as_s?
            hash["budget_item_id"] = subtransaction["budget_item_id"].as_i?
            hash["primary_transaction_id"] = subtransaction["primary_transaction_id"].as_i?
            hash["icon_class_name"] = subtransaction["icon_class_name"].as_s?
          end
        end
        Entry.new(attrs, subtransactions)
      end
    end
  end
end
