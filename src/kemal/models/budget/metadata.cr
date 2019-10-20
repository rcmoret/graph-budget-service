require "graphql-crystal"

module Budget
  class Metadata
    include GraphQL::ObjectType
    getter data

    def initialize(data : JSON::Any)
      @data = data
    end

    field :month { data["month"].as_i }
    field :year { data["year"].as_i }
    field :isSetUp { data["is_set_up"].as_bool }
    field :isClosedOut { data["is_closed_out"].as_bool }
    field :daysRemaining { data["days_remaining"].as_i }
    field :spent { data["spent"].as_i }
  end
end
