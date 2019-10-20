require "graphql-crystal"

module Transaction
  class Wrapper
    include GraphQL::ObjectType
    getter options

    def initialize(options : Hash(String, String))
      @options = options
    end

    field :metadata do
      @metadata ||= Metadata.new(parsed_response["metadata"])
    end

    field :collection do
      parsed_response["transactions"].as_a.map do |entry_attrs|
        Entry::Factory.create_from_json(entry_attrs)
      end
    end

    private def parsed_response : JSON::Any
      @parsed_response ||= JSON.parse(response_body)
    end

    private def response_body : String
      Rest::Client.get(endpoint).body
    end

    private def endpoint : String
      "accounts/#{account_id}/transactions?month=#{month}&year=#{year}"
    end

    private def account_id : Int32
      options["account_id"].to_i
    end

    private def month : Int32
      options["month"].to_i
    end

    private def year : Int32
      options["year"].to_i
    end
  end
end
