require "graphql-crystal"

module Budget
  class Wrapper
    include GraphQL::ObjectType
    getter month
    getter year

    def initialize(month : String, year : String)
      @month = month
      @year = year
    end

    field :metadata do
      Metadata.for(month, year)
    end

    field :collection do
      Item.for(month, year)
    end
  end
end
