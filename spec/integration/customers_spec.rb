require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Customers" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch logged in customer" do
    customer = Nurego::Customer.me
    customer["object"].should == "customer"
    customer["email"].should == EXAMPLE_EMAIL
  end

  it "can retrieve customer by id" do
    customer = Nurego::Customer.me

    customer0 = Nurego::Customer.retrieve(id: customer[:id])
    customer0["email"] == EXAMPLE_EMAIL
  end

  it "can retrieve organization from customer" do
    customer = Nurego::Customer.me
    organization = customer.organization
    organization["object"].should == "organization"
  end

  it "can update the plan to the same plan" do
    customer = Nurego::Customer.me

    plan_guid = customer[:plan_id]
    Nurego::Customer.update_plan(plan_guid, customer[:subscriptions][:data][0][:id])

    customer = Nurego::Customer.me
    customer[:plan_id].should_not be_nil
  end

  it "can retrieve multiple plans format" do
    customer = Nurego::Customer.me
    customer[:subscriptions].should_not be_nil
    customer[:subscriptions].count.should eq 1
    customer[:subscriptions][:data][0].should_not be_nil
    customer[:subscriptions][:data][0][:plan][:id].should_not be_nil
  end


  it "can update the plan to different plan" do
    customer = Nurego::Customer.me
    offering = Nurego::Offering.current
    plan_guid = offering.plans[:data][1][:id] || customer[:plan_id]
    Nurego::Customer.update_plan(plan_guid, customer[:subscriptions][:data][0][:id])
    customer = Nurego::Customer.me
    customer[:subscriptions][:data][0][:plan][:id].should eq plan_guid

  end

  it "can cancel the customer account" do
    Nurego::Customer.cancel_account
    customer = Nurego::Customer.me
#    customer[:plan_id].should be_nil      # todo: by default, subscriptions are not managed by nurego.

    ENV['CUSTOMER_SET'] = "no"

    # TODO find a way to set it w/o warning
    EXAMPLE_EMAIL = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
  end
end
