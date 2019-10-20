require "graphql-crystal"

module Transaction
  class Metadata
    include GraphQL::ObjectType
    getter data

    def initialize(data : JSON::Any)
      @data = data
    end

    field :priorBalance { data["prior_balance"].as_i }
    field :month { query_options["month"].to_s.to_i }
    field :year { query_options["year"].to_s.to_i }
    field :accountId { query_options["account_id"].to_s.to_i }
    field :includePending { query_options["include_pending"].as_bool }
    field :dateRange do
      data["date_range"].as_a.map do |date_string|
        date_string.to_s
      end
    end

    private def query_options
      data["query_options"].as_h
    end
  end
end
