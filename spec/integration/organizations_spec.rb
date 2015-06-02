require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Organizations" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can retrieve instances" do
    customer = Nurego::Customer.me
    organization = customer.organization
    instances = organization.instances
    instances.count.should == 2
    instances.each do |instance|
      instance["object"] == "instance"
    end
  end

  it "can update org name" do
    customer = Nurego::Customer.me
    organization = customer.organization
    organization.name.should_not eq 'new name'
    organization[:name] = 'new name'
    organization.save
    customer = Nurego::Customer.me
    organization = customer.organization
    organization.name.should eq 'new name'
  end

  it "can retrieve payment method" do
    # TODO create a real payment method here

    customer = Nurego::Customer.me
    organization = customer.organization
    paymentmethod = organization.paymentmethod
    paymentmethod["object"].should == "paymentmethod"
  end

  it "can retrieve the bill" do
    # TODO create a real bill

    customer = Nurego::Customer.me
    organization = customer.organization
    bills = organization.bills
    bill = Nurego::Bill.retrieve(id: bills[:data][0][:id]) if bills[:count] > 0
    bill["object"].should == "bill" if bill
  end

  # todo: use the same method to update coupons and check results
  it "can update organization's subscription" do
    customer = Nurego::Customer.me
    organization = customer.organization
    organization[:plan] = Nurego::Plan.new(customer[:plan_id])
    trial = Nurego::Discount.new
    trial[:trial_days] = 123
    organization[:trial] = trial
#    organization[:coupon] = Nurego::Discount.new('discount_id')
    organization.save
  end

  it "can fetch the current plan" do
    customer = Nurego::Customer.me
    organization = customer.organization

    plan = organization.plan
    plan["object"].should == "plan"
  end

  it "can fetch feature data" do
    customer = Nurego::Customer.me
    organization = customer.organization

    res = organization.feature_data({feature_id: 'some feature id'})            
    res["object"].should == "list"
    res["data"].should be_empty
  end

  # todo: this shows how to use the API, but will do nothing because by default subscriptions are not managed internally
  it "can cancel a subscription" do
    customer = Nurego::Customer.me
    organization = customer.organization
    organization.cancel({ :plan => { :id => customer[:plan_id]} })
    organization = customer.organization
  end

  # todo: this shows how to use the API, but will do nothing because by default subscriptions are not managed internally
  it "can cancel an account" do
    customer = Nurego::Customer.me
    organization = customer.organization
    organization.cancel
    organization = customer.organization
  end

end