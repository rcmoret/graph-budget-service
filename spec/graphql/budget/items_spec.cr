require "spec"
require "../../../src/kemal/graphql/schema"
require "webmock"

describe Budget::GraphQL do
  describe ".execute" do
    context "when calling the budget items endpoint" do
      it "should return data" do
        month = 8
        year = 2019
        WebMock.stub(:get, "#{Rest::Client::BASE_URL}/budget/items?month=#{month}&year=#{year}")
          .to_return(
             body: File.read("./spec/support/budget_items.json"),
             status: 200
          )
        WebMock.stub(:get, "#{Rest::Client::BASE_URL}/budget/items/metadata?month=#{month}&year=#{year}")
          .to_return(
             body: File.read("./spec/support/budget_items_metadata.json"),
             status: 200
          )

        query_string = %{
          {
            budgetItems(month: "#{month}", year: "#{year}") {
              metadata {
                month
                year
                isSetUp
                isClosedOut
                daysRemaining
                spent
              }
              collection {
                id
                name
                amount
                spent
                accrual
                month
                year
                spent
                budgetCategoryId
                iconClassName
                transactionCount
                maturityMonth
                maturityYear
              }
            }
          }
        }

        expected_return = {
          "data" => {
            "budgetItems" => {
              "metadata" => {
                "month" => month,
                "year" => year,
                "isSetUp" => false,
                "isClosedOut" => false,
                "daysRemaining" => 31,
                "spent" => 0,
              },
              "collection" => [
                {
                  "id" => 2714,
                  "name" => "Salary",
                  "amount" => 263614,
                  "spent" => 0,
                  "accrual" => false,
                  "month" => month,
                  "year" => year,
                  "budgetCategoryId" => 1,
                  "iconClassName" => "fas fa-dollar-sign",
                  "transactionCount" => 0,
                  "maturityMonth" => nil,
                  "maturityYear" => nil,
                },
                {
                  "id" => 2715,
                  "name" => "Salary",
                  "amount" => 263614,
                  "spent" => 0,
                  "accrual" => false,
                  "month" => month,
                  "year" => year,
                  "budgetCategoryId" => 1,
                  "iconClassName" => "fas fa-dollar-sign",
                  "transactionCount" => 0,
                  "maturityMonth" => nil,
                  "maturityYear" => nil,
                },
              ],
            }
          }
        }

        Budget::GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
