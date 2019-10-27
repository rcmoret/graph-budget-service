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
          id: ID!
          name: String!
          balance: Int!
          priority: Int!
          cashFlow: Boolean!
        }

        type BudgetCategoryType {
          id: ID!
          name: String!
          expense: Boolean!
          monthly: Boolean!
          accrual: Boolean!
          defaultAmount: Int!
          iconClassName: String
        }

        type BudgetItemsType {
          metadata: BudgetMetadataType
          collection: [BudgetItemType]
        }

        type BudgetMetadataType {
          month: Int!
          year: Int!
          isClosedOut: Boolean!
          isSetUp: Boolean!
          daysRemaining: Int!
          spent: Int!
        }

        type BudgetItemType {
          id: ID!
          name: String!
          amount: Int!
          spent: Int!
          accrual: Boolean!
          month: Int!
          year: Int!
          spent: Int!
          budgetCategoryId: Int!
          iconClassName: String!
          transactionCount: Int!
          maturityMonth: Int!
          maturityYear: Int!
          transactions: [TransactionEntryType]
        }

        type TransactionsType {
          metadata: TransactionMetadataType
          collection: [TransactionEntryType]
        }

        type TransactionMetadataType {
          priorBalance: Int!
          dateRange: [String!]
          month: Int!
          year: Int!
          accountId: Int!
          includePending: Boolean!
        }

        type TransactionEntryType {
          id: ID!
          accountId: Int!
          description: String
          clearanceDate: String
          checkNumber: String
          notes: String
          budgetExclusion: Boolean!
          accountName: String!
          primaryTransactionId: Int
          details: [TransactionDetailType]
        }

        type TransactionDetailType {
          amount: Int!
          budgetCategory: String
          budgetItemId: Int
          iconClassName: String
          primaryTransactionId: Int
        }
      }
    )

    SCHEMA.tap do |schema|
      schema.query_resolver = QueryType
    end
  end
end
