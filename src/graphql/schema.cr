require "graphql-crystal"
require "../models/account"
require "../models/icon"
require "../models/budget/*"
require "../models/transaction/*"
require "../models/transfer/*"

module QueryType
  include GraphQL::ObjectType
  extend self

  field :accounts do
    Account.all
  end

  field :budget_categories do
    Budget::Category.all
  end

  field :budget_category do
    Budget::Category.find(args["id"].as(Int32))
  end

  field :budget_items do |args|
    Budget::Wrapper.new(args["month"].as(Int32), args["year"].as(Int32))
  end

  field :transactions do |args|
    Transaction::Wrapper.new({
      "account_id" => args["account_id"].as(Int32),
      "month" => args["month"].as(Int32),
      "year" => args["year"].as(Int32)
    })
  end

  field :budget_item do |args|
    Budget::Item.find(args["category_id"].as(Int32), args["item_id"].as(Int32))
  end

  field :transfers do |args|
    limit = args.fetch("limit", 10).as(Int32)
    page = args.fetch("page", 1).as(Int32)
    Transfer::Wrapper.fetch(page, limit)
  end

  field :icons do
    Icon.all
  end

  field :icon do |args|
    Icon.find(args["id"].as(Int32))
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
          budget_category(id: Int!): BudgetCategoryType
          budget_categories: [BudgetCategoryType]
          budget_item(category_id: Int!, item_id: Int!): BudgetItemType
          budget_items(month: Int!, year: Int!): BudgetItemsType
          transactions(account_id: Int!, month: Int!, year: Int!): TransactionsType
          transfers(limit: Int!, page: Int!): TransfersType
          icons: [IconType]
          icon(id: Int!): IconType
        }

        type AccountType {
          id: ID!
          name: String!
          balance: Int!
          priority: Int!
          cash_flow: Boolean!
        }

        type BudgetCategoryType {
          id: ID!
          name: String!
          expense: Boolean!
          monthly: Boolean!
          accrual: Boolean!
          default_amount: Int!
          icon_class_name: String
          icon_id: Int
          maturity_intervals: [BudgetCategoryMaturityIntervalType]
        }

        type BudgetItemsType {
          metadata: BudgetMetadataType
          collection: [BudgetItemType]
        }

        type BudgetMetadataType {
          month: Int!
          year: Int!
          balance: Int!
          is_closed_out: Boolean!
          is_set_up: Boolean!
          days_remaining: Int!
          spent: Int!
          total_days: Int!
        }

        type BudgetItemType {
          id: ID!
          name: String!
          amount: Int!
          spent: Int!
          accrual: Boolean!
          expense: Boolean!
          monthly: Boolean!
          month: Int!
          year: Int!
          spent: Int!
          budget_category_id: Int!
          icon_class_name: String!
          transaction_count: Int!
          maturity_month: Int!
          maturity_year: Int!
          transactions: [TransactionEntryType]
        }

        type BudgetCategoryMaturityIntervalType {
          id: ID!
          month: Int!
          year: Int!
          categoryId: Int!
        }

        type TransactionsType {
          metadata: TransactionMetadataType
          collection: [TransactionEntryType]
        }

        type TransactionMetadataType {
          prior_balance: Int!
          date_range: [String!]
          month: Int!
          year: Int!
          account_id: Int!
          include_pending: Boolean!
        }

        type TransactionEntryType {
          id: ID!
          account_id: Int!
          description: String
          clearance_date: String
          check_number: String
          notes: String
          budget_exclusion: Boolean!
          account_name: String!
          details: [TransactionDetailType]
        }

        type TransactionDetailType {
          id: Int
          amount: Int!
          budget_category: String
          budget_item_id: Int
          icon_class_name: String
        }

        type TransfersType {
          metadata: TransferMetadataType
          collection: [TransferEntryType]
        }

        type TransferMetadataType {
          offset: Int!
          limit: Int!
          viewing: [Int]
          total: Int!
        }

        type TransferEntryType {
          id: ID!
          to_transaction_id: Int!
          from_transaction_id: Int!
          to_transaction: TransactionEntryType
          from_transaction: TransactionEntryType
        }

        type IconType {
          id: ID!
          class_name: String!
          name: String!
        }
      }
    )
    SCHEMA.tap do |schema|
      schema.query_resolver = QueryType
    end
  end
end
