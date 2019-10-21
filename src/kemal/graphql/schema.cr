require "graphql-crystal"
require "../models/account"
require "../models/budget/*"
require "../models/transaction/*"

module QueryType
  include GraphQL::ObjectType
  extend self

  field :accounts do
    Account.all
  end

  field :budgetCategories do
    Budget::Category.all
  end

  field :budgetItems do |args|
    Budget::Wrapper.new(args["month"], args["year"])
  end

  field :transactions do |args|
    Transaction::Wrapper.new({
      "account_id" => args["accountId"].to_s,
      "month" => args["month"].to_s,
      "year" => args["year"].to_s
    })
  end

  field :budgetItem do |args|
    Budget::Item.find(args["categoryId"].to_s.to_i, args["itemId"].to_s.to_i)
  end
end

module Budget
  module GraphQL
    SCHEMA = ::GraphQL::Schema.from_schema(
      %{
        schema {
          query: QueryType
        }

        type QueryType {
          accounts: [AccountType]
          budgetCategories: [BudgetCategoryType]
          budgetItem(categoryId: String!, itemId: String!): BudgetItemType
          budgetItems(month: String!, year: String!): BudgetItemsType
          transactions(accountId: String!, month: String!, year: String!): TransactionsType
        }

        type AccountType {
          id: String!
          name: String!
          balance: String!
          priority: String!
          cashFlow: String
        }

        type BudgetCategoryType {
          id: String!
          name: String!
          expense: String!
          monthly: String!
          accrual: String!
          defaultAmount: String!
          iconClassName: String
        }

        type BudgetItemsType {
          metadata: BudgetMetadataType
          collection: [BudgetItemType]
        }

        type BudgetMetadataType {
          month: String!
          year: String!
          isClosedOut: String!
          isSetUp: String!
          daysRemaining: String!
          spent: String!
        }

        type BudgetItemType {
          id: String!
          name: String!
          amount: String!
          spent: String!
          accrual: String!
          month: String!
          year: String!
          spent: String!
          budgetCategoryId: String!
          iconClassName: String!
          transactionCount: String!
          maturityMonth: String!
          maturityYear: String!
          transactions: [TransactionEntryType]
        }

        type TransactionsType {
          metadata: TransactionMetadataType
          collection: [TransactionEntryType]
        }

        type TransactionMetadataType {
          priorBalance: String!
          dateRange: [String!]
          month: String!
          year: String!
          accountId: String!
          includePending: String!
        }

        type TransactionEntryType {
          id: String!
          description: String
          clearanceDate: String
          checkNumber: String
          notes: String
          budgetExclusion: String!
          accountName: String!
          primaryTransactionId: String
          details: [TransactionDetailType]
        }

        type TransactionDetailType {
          amount: String!
          budgetCategory: String
          budgetItemId: String
          iconClassName: String
          primaryTransactionId: String
        }
      }
    )

    SCHEMA.tap do |schema|
      schema.query_resolver = QueryType
    end
  end
end
