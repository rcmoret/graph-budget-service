require "spec"
require "../../../src/kemal/graphql/schema"
require "webmock"

describe GraphQL do
  describe ".execute" do
    context "when calling the budget categories endpoint" do
      it "should return data" do
        WebMock.stub(:get, "localhost:8088/budget/categories")
          .to_return(
             body: File.read("./spec/support/budget_categories.json"),
             status: 200
          )

        query_string = %{
          {
            budgetCategories {
              id
              name
              expense
              monthly
              defaultAmount
              iconClassName
            }
          }
        }

        expected_return = {
          "data" => {
            "budgetCategories" => [
              {
                "id" => 104,
                "name" => "Tennessean",
                "expense" => true,
                "monthly" => true,
                "defaultAmount" => -999,
                "iconClassName" => "fas fa-newspaper",
              },
              {
                "id" => 110,
                "name" => "AT&T",
                "expense" => true,
                "monthly" => true,
                "defaultAmount" => -5000,
                "iconClassName" => "fas fa-file-invoice-dollar",
              }
            ]
          }
        }
        GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
