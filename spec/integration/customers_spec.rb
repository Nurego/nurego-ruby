require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Customers" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch logged in customer" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    customer["object"].should == "customer"
    customer["email"].should == EXAMPLE_EMAIL
  end

  it "can retrieve customer by id" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)

    customer0 = Nurego::Customer.retrieve(id: customer[:id])
    customer0["email"] == EXAMPLE_EMAIL
  end

  it "can retrieve organization from customer" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    organization = customer.organization
    organization["object"].should == "organization"
  end

  xit "can update the plan to the same plan" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)

    subs = customer[:subscriptions][:data]
    subs.size.should be > 0

    plan_guid = subs[0][:plan][:id]
    Nurego::Customer.update_plan(plan_guid, customer[:subscriptions][:data][0][:id])

    customer = Nurego::Customer.retrieve(@uaa_user_id)
    customer[:subscriptions][:data][0][:plan][:id].should_not be_nil
  end

  it "can retrieve multiple plans format" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    customer[:subscriptions].should_not be_nil
    customer[:subscriptions].count.should be > 0
    customer[:subscriptions][:data][0].should_not be_nil
    customer[:subscriptions][:data][0][:plan][:id].should_not be_nil
  end


  xit "can update the plan to different plan" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    offering = Nurego::Offering.current
    plan_guid = offering.plans[:data][1][:id] || customer[:plan_id]
    Nurego::Customer.update_plan(plan_guid, customer[:subscriptions][:data][0][:id])
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    customer[:subscriptions][:data][0][:plan][:id].should eq plan_guid

  end

  xit "can cancel the customer account" do
    Nurego::Customer.cancel_account
    customer = Nurego::Customer.retrieve(@uaa_user_id)
#    customer[:plan_id].should be_nil      # todo: by default, subscriptions are not managed by nurego.

    ENV['CUSTOMER_SET'] = "no"

    # TODO find a way to set it w/o warning
    EXAMPLE_EMAIL = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
  end
end
