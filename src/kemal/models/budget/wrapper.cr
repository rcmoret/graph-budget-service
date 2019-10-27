require "graphql-crystal"

module Budget
  class Wrapper
    include GraphQL::ObjectType
    getter month
    getter year

    def initialize(month : Int32, year : Int32)
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
