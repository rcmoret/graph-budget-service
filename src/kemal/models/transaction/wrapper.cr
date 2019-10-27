require "graphql-crystal"

module Transaction
  class Wrapper
    include GraphQL::ObjectType
    getter options

    def initialize(options : Hash(String, Int32))
      @options = options
    end

    field :metadata do
      @metadata ||= Metadata.for(account_id, month, year)
    end

    field :collection do
      @collection ||= Entry.for(account_id, month, year)
    end

    private def account_id
      options["account_id"]
    end

    private def month
      options["month"]
    end

    private def year
      options["year"]
    end
  end
end
