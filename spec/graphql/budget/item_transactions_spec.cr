require "spec"
require "../../../src/kemal/graphql/schema"
require "webmock"

describe Budget::GraphQL do
  describe ".execute" do
    context "when calling the item/transactions endpoint" do
      it "returns some data" do
        txn_id = 9474
        budget_category_id = 180
        budget_item_id = 2394
        path = "budget/categories/#{budget_category_id}/items/#{budget_item_id}/transactions"
        WebMock.stub(:get, "#{Rest::Client::BASE_URL}/#{path}")
          .to_return(
             body: File.read("./spec/support/budget_item_transactions.json"),
             status: 200
          )

        [
          {
            "id" => txn_id,
            "account_id" => 17,
          },
          {
            "id" => 9377,
            "account_id" => 17,
          },
          {
            "id" => 9473,
            "account_id" => 17,
          },
          {
            "id" => 9514,
            "account_id" => 17,
          },
          {
            "id" => 9376,
            "account_id" => 17,
          },
          {
            "id" => 9515,
            "account_id" => 17,
          },
          {
            "id" => 8557,
            "account_id" => 1,
          },
        ].each do |hash|
          txn_path = "accounts/#{hash["account_id"]}/transactions/#{hash["id"]}"
          WebMock.stub(:get, "#{Rest::Client::BASE_URL}/#{txn_path}")
            .to_return(
               body: File.read("./spec/support/transaction.json"),
               status: 200
            )
        end

        item_path = "budget/categories/#{budget_category_id}/items/#{budget_item_id}"
        WebMock.stub(:get, "#{Rest::Client::BASE_URL}/#{item_path}")
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
                  "accountName" => "Aspiration (ck)",
                  "clearanceDate" => "2019-09-30",
                  "description" => "Chick-fil-A",
                  "details" => [
                    {
                      "amount" => -869,
                    },
                  ],
                },
                {
                  "accountName" => "Aspiration (ck)",
                  "clearanceDate" => "2019-10-12",
                  "description" => "Chick-fil-A",
                  "details" => [
                    {
                      "amount" => -4500,
                    },
                  ],
                },
                {
                  "accountName" => "Aspiration (ck)",
                  "clearanceDate" => nil,
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

        Budget::GraphQL::SCHEMA.execute(query_string).should eq expected_return
      end
    end
  end
end
