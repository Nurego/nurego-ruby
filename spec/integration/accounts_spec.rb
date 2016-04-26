require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Accounts" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can retrieve account by accout no" do
    account1 = Nurego::Customer.me.organization.account
    expect(account1["object"]).to eq "account"
    account2 = Nurego::Account.retrieve(account1[:account_no])
    expect(account2["object"]).to eq "account"
    expect(account2.to_s).to eq account1.to_s
  end

  it "can update account name" do
    account = Nurego::Customer.me.organization.account
    expect(account.name).not_to eq 'new name'
    account[:name] = 'new name'
    account.update
    account = Nurego::Customer.me.organization.account
    expect(account.name).to eq 'new name'
  end

  it "can update account bill to contact" do
    account = Nurego::Customer.me.organization.account
    expect(account[:bill_to_contact]).to eq nil
    bill_to_contact = {
        address: 'address1',
        address2: 'address2',
        city: 'city',
        country: 'country',
        zip_code: 'zipcode',
        state:'state',
        first_name: 'firstname',
        last_name: 'lastname',
        email: 'test@nurego.com',
        additional_details: {}
    }
    account[:bill_to_contact] = bill_to_contact
    account.update
    account = Nurego::Customer.me.organization.account
    expect(account.bill_to_contact).not_to eq nil
  end
end
