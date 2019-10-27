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
    Budget::Wrapper.new(args["month"].as(Int32), args["year"].as(Int32))
  end

  field :transactions do |args|
    Transaction::Wrapper.new({
      "account_id" => args["accountId"].as(Int32),
      "month" => args["month"].as(Int32),
      "year" => args["year"].as(Int32)
    })
  end

  field :budgetItem do |args|
    Budget::Item.find(args["categoryId"].as(Int32), args["itemId"].as(Int32))
  end

  # field :transfers do |args|
  #   limit = args.fetch("limit", 10).as(Int32)
  #   offset = args.fetch("offset", 0).as(Int32)
  #   Transfer::Wrapper.fetch(offset, limit)
  # end
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
          budgetItem(categoryId: Int!, itemId: Int!): BudgetItemType
          budgetItems(month: Int!, year: Int!): BudgetItemsType
          transactions(accountId: Int!, month: Int!, year: Int!): TransactionsType
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
          amount: Int!
          spent: Int!
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
          accountId: String!
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
