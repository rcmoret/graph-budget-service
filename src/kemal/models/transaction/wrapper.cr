require "graphql-crystal"

module Transaction
  class Wrapper
    include GraphQL::ObjectType
    getter options

    def initialize(options : Hash(String, String))
      @options = options
    end

    field :metadata do
      @metadata ||= Metadata.for(account_id, month, year)
    end

    field :collection do
      @collection ||= Entry.for(account_id, month, year)
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
