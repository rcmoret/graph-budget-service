require "graphql-crystal"

module Transfer
  class Wrapper
    include GraphQL::ObjectType
    include JSON::Serializable

    def self.fetch(page, limit)
      response = Rest::Client.get("transfers?page=#{page}&per_page=#{limit}")
      from_json(response.body)
    end

    @[JSON::Field(key: "metadata")]
    getter metadata : Metadata
    field :metadata

    @[JSON::Field(key: "transfers")]
    getter collection : Array(Entry)
    field :collection
  end
end
