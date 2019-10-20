require "spec"
require "../../../src/kemal/graphql/schema"
require "webmock"

describe GraphQL do
  describe ".execute" do
    context "when calling the item/transactions endpoint" do
      it "returns some data" do
        txn_id = 8558
        budget_category_id = 180
        budget_item_id = 2394
        account_id = 1
        path = "budget/categories/#{budget_category_id}/items/#{budget_item_id}/transactions"
        WebMock.stub(:get, "localhost:8088/#{path}")
          .to_return(
             body: File.read("./spec/support/budget_item_transactions.json"),
             status: 200
          )

        txn_path = "accounts/#{account_id}/transactions/#{txn_id}"
        WebMock.stub(:get, "localhost:8088/#{txn_path}")
          .to_return(
             body: File.read("./spec/support/transaction.json"),
             status: 200
          )

        item_path = "budget/categories/#{budget_category_id}/items/#{budget_item_id}"
        WebMock.stub(:get, "localhost:8088/#{item_path}")
          .to_return(
             body: File.read("./spec/support/budget_item.json"),
             status: 200
          )

        query_string = %{
          {
            budgetItem(categoryId: "#{budget_category_id}", itemId: "#{budget_item_id}") {
              transactions {
                accountName
                clearanceDate
                description
                details {
                  amount
                }
              }
            }
          }
        }

        expected_return = {
          "data" => {
            "budgetItem" => {
              "transactions" => [
                {
                  "accountName" => "Checking",
                  "clearanceDate" => "2019-07-01",
                  "description" => "Chick-fil-A",
                  "details" => [
                    {
                      "amount" => -869,
                    },
                  ],
                },
                {
                  "accountName" => "Checking",
                  "clearanceDate" => "2019-07-01",
                  "description" => "Chick-fil-A",
                  "details" => [
                    {
                      "amount" => -4500,
                    },
                  ],
                },
                {
                  "accountName" => "Checking",
                  "clearanceDate" => "2019-07-01",
                  "description" => "Chick-fil-A",
                  "details" => [
                    {
                      "amount" => -2050,
                    },
                  ],
                },
              ],
            }
          }
        }

        GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
