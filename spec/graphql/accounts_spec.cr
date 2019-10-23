require "spec"
require "../../src/kemal/graphql/schema"
require "webmock"

describe Budget::GraphQL do
  describe ".execute" do
    context "when calling the accounts endpoint" do
      it "should return data" do
        WebMock.stub(:get, "#{Rest::Client::BASE_URL}/accounts")
          .to_return(
             body: File.read("./spec/support/accounts.json"),
             status: 200
          )

        query_string = %{
          {
            accounts {
              id
              name
              balance
              priority
              cashFlow
            }
          }
        }

        expected_return = {
          "data" => {
            "accounts" => [
              {
                "id" => 18,
                "name" => "Aspiration (s)",
                "balance" => 199103,
                "priority" => 355,
                "cashFlow" => false
              },
              {
                "id" => 7,
                "name" => "First Tenn. (cr)",
                "balance" => -268538,
                "priority" => 250,
                "cashFlow" => false
              }
            ]
          }
        }

        Budget::GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
