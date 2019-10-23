require "spec"
require "../../src/kemal/graphql/schema"
require "webmock"

describe Budget::GraphQL do
  describe ".execute" do
    context "when calling the transactions endpoint" do
      it "should return data" do
        account_id = 12
        month = 9
        year = 2019
        WebMock.stub(:get, "localhost:8088/accounts/#{account_id}/transactions?month=#{month}&year=#{year}")
          .to_return(
             body: File.read("./spec/support/transactions.json"),
             status: 200
          )

        query_string = %{
          {
            transactions(month: "#{month}", year: "#{year}", accountId: "#{account_id}") {
              metadata {
                priorBalance
                dateRange
                month
                year
                accountId
                includePending
              }
              collection {
                id
                description
                accountName
                clearanceDate
                checkNumber
                notes
                budgetExclusion
                details {
                  amount
                  budgetCategory
                  budgetItemId
                  iconClassName
                  primaryTransactionId
                }
              }
            }
          }
        }

        expected_return = {
          "data" => {
            "transactions" => {
              "metadata" => {
                "priorBalance" => -5021582,
                "dateRange" => ["2019-09-01", "2019-09-30"],
                "month" => month,
                "year" => year,
                "accountId" => account_id,
                "includePending" => false,
              },
              "collection" => [
                {
                  "id" => 9501,
                  "description" => "Payment",
                  "accountName" => "Student Loan (d)",
                  "clearanceDate" => "2019-09-24",
                  "checkNumber" => "",
                  "notes" => nil,
                  "budgetExclusion" => true,
                  "details" => [
                    {
                      "amount" => 60000,
                      "budgetCategory" => "Groceries",
                      "budgetItemId" => 88,
                      "iconClassName" => "fas fa-joint",
                      "primaryTransactionId" => nil,
                    },
                  ],
                },
                {
                  "id" => 9290,
                  "description" => "Payment",
                  "accountName" => "Student Loan (d)",
                  "clearanceDate" => "2019-09-18",
                  "checkNumber" => "",
                  "notes" => nil,
                  "budgetExclusion" => true,
                  "details" => [
                    {
                      "amount" => 5700,
                      "budgetCategory" => "Misc. Income",
                      "budgetItemId" => 2877,
                      "iconClassName" => "fas fa-money-bill-wave",
                      "primaryTransactionId" => 9290,
                    },
                    {
                      "amount" => 4300,
                      "budgetCategory" => "Reinvestment",
                      "budgetItemId" => 2897,
                      "iconClassName" => "fas fa-wrench",
                      "primaryTransactionId" => 9290,
                    },
                  ],
                },
              ]
            }
          }
        }
        Budget::GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
