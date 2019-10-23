require "spec"
require "webmock"
require "../../src/kemal/models/account"

describe Account do
  describe ".from_json" do
    body = File.read("./spec/support/account.json")
    subject = Account.from_json(body)

    it "returns a new instance with the correct id" do
      subject.id.should eq 18
    end

    it "returns a new instance with the correct name" do
      subject.name.should eq "Aspiration"
    end

    it "returns a new instance with the correct balance" do
      subject.balance.should eq 199103
    end

    it "returns a new instance with the correct priority" do
      subject.priority.should eq 355
    end

    it "returns a new instance with the correct cash flow" do
      subject.cash_flow.should eq true
    end
  end

  describe ".all" do
    WebMock.stub(:get, "#{Rest::Client::BASE_URL}/accounts")
      .to_return(body: File.read("./spec/support/accounts.json"),
                 status: 200)

    it "returns some accounts" do
      Account.all.size.should eq 2
    end
  end
end
