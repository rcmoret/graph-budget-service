require "graphql-crystal"

module Budget
  class Wrapper
    include GraphQL::ObjectType
    getter parsed_response

    def initialize(month, year)
      response = Rest::Client.get("budget/items?month=#{month}&year=#{year}")
      @parsed_response = JSON.parse(response.body)
    end

    field :metadata do
      Metadata.new(parsed_response["metadata"])
    end

    field :collection do
      parsed_response["collection"].as_a.map do |item_attrs|
        Item.from_json(item_attrs)
      end
    end
  end
end
