require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Organizations" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can retrieve instances" do
    customer = Nurego::Customer.me
    organization = customer.organizations
    instances = organization[0].instances
    instances.size.should == 2
    instances.each do |instance|
      instance["object"] == "instance"
    end
  end

  it "can update org name" do
    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    organization[:name] = 'new name'
    organization.save
#    organization = Nurego::Organization.retrieve(organization[:id])  - todo: fix: can't retrieve self for now
  end

  it "can retrieve payment method" do
    # TODO create a real payment method here

    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    paymentmethod = organization.paymentmethod
    paymentmethod["object"].should == "paymentmethod"
  end

  it "can retrieve the bill" do
    # TODO create a real bill

    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    bills = organization.bills
    bill = Nurego::Bill.retrieve(id: bills[:data][0][:id]) if bills[:count] > 0
    bill["object"].should == "bill" if bill
  end

  # todo: use the same method to update coupons and check results
  it "can update organization's subscription" do
    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    organization[:plan] = Nurego::Plan.new(customer[:plan_id])
    trial = Nurego::Discount.new
    trial[:trial_days] = 123
    organization[:trial] = trial
#    organization[:coupon] = Nurego::Discount.new('discount_id')
    organization[:external_ids] = false
    organization.save
  end

  it "can fetch the current plan" do
    customer = Nurego::Customer.me
    organization = customer.organizations[0]

    plan = organization.plan({:external_ids => false})
    plan["object"].should == "plan"
  end

  # todo: this shows how to use the API, but will do nothing because by default subscriptions are not managed internally
  it "can cancel a subscription" do
    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    organization.cancel({ :external_ids => false, :plan => { :id => customer[:plan_id]} })
    organization = customer.organizations[0]
  end

  # todo: this shows how to use the API, but will do nothing because by default subscriptions are not managed internally
  it "can cancel an account" do
    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    organization.cancel({ :external_ids => false })
    organization = customer.organizations[0]
  end

end