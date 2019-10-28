require "./kemal"
require "./graphql/schema"

module Kemal::GraphQL
  private def self.extract_graphql_payload(type : Symbol, env)
    case type
    when :query
      query_string = env.params.query["query"]
      query_params = env.params.query.has_key?("variables") ?
                       JSON.parse(env.params.query["variables"]).as_h : nil
    when :json
      payload = env.params.json
      query_string = payload["query"].as(String)
      query_params = payload["variables"]?.as Hash(String, JSON::Any)?
    end
    context = ::GraphQL::Schema::Context.new(
      Budget::GraphQL::SCHEMA
    )
    raise "no query provided!" unless query_string
    { query_string, query_params, nil, context }
  end

  #
  # read query and variables from the request uri
  #
  get "/api_query" do |env|
    env.response.content_type = "application/json"
    env.response.headers.add("Access-Control-Allow-Origin", "*")
    Budget::GraphQL::SCHEMA.execute(
      *extract_graphql_payload(:query, env)
    ).to_json
  end

  options "/graphql" do |env|
    env.response.headers.add("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
    env.response.headers.add("Access-Control-Allow-Headers", "content-type")
    env.response.headers.add("Access-Control-Allow-Origin", "*")
    env.response.content_type = "application/json"
    "hello world"
  end
  #
  # read query and variable from the json request body
  #
  post "/graphql" do |env|
    env.response.content_type = "application/json"
    env.response.headers.add("Access-Control-Allow-Origin", "*")
    Budget::GraphQL::SCHEMA.execute(
      *extract_graphql_payload(:json, env)
    ).to_json
  end

  Kemal.run
end
