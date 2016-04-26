require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Accounts" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can retrieve account" do
    customer = Nurego::Customer.me
    account = customer.organization.account
    account["object"].should == "account"
  end

  it "can update account" do
    customer = Nurego::Customer.me
    account = customer.organization.account
    account.name.should_not eq 'new name'
    account[:name] = 'new name'
    account.update
    customer = Nurego::Customer.me
    account = customer.organization.account
    account.name.should eq 'new name'
  end
end
