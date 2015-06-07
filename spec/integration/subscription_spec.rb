require File.join(File.dirname(__FILE__), 'spec_helper')
describe "Subscriptions" do

  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  def create_subscription(organization, plan)
    create_params = { plan_id: plan.id }
    Nurego::Subscription.create(organization.id, create_params)
  end

  it "can create a subscription" do
    plan = Nurego::Offering.current.plans.first
    organization = Nurego::Customer.me.organization
    current_subscriptions = Nurego::Customer.me.subscriptions.data
    sub = create_subscription(organization, plan)
    expect(sub).to be_a_kind_of(Nurego::Subscription)
    expect(sub.plan_id).to eq plan.id
    expect(sub.organization_id).to eq organization.id
    expect(Nurego::Customer.me.subscriptions.data.count).to eq current_subscriptions.count+1
    expect(Nurego::Customer.me.subscriptions.data.any? { |subscription| subscription.id == sub.id }).to be_true
  end

  it "can retrieve a subscription" do
    plan = Nurego::Offering.current.plans.first
    organization = Nurego::Customer.me.organization
    sub = create_subscription(organization, plan)
    sub2 = Nurego::Subscription.retrieve(sub.id)
    expect(sub2.id).to eq(sub.id)
    expect(sub2.plan_id).to eq(sub.plan_id)
    expect(sub2.organization_id).to eq(sub.organization_id)
    expect(sub2.subscription_start).to eq(sub.subscription_start)
  end

  it "can update a subscription" do
    plan = Nurego::Offering.current.plans.first
    organization = Nurego::Customer.me.organization
    sub = create_subscription(organization, plan)
    expect(Nurego::Offering.current.plans.data[1]).not_to be_nil
    plan2 = Nurego::Offering.current.plans.data[1].id
    sub.plan_id = plan2
    id = sub.id
    sub.save
    expect(sub.id).not_to eq id
  end

  it "can delete a subscription" do
    plan = Nurego::Offering.current.plans.first
    organization = Nurego::Customer.me.organization
    sub = create_subscription(organization, plan)
    id = sub.id
    now = Time.now
    sub.delete
    sub = Nurego::Subscription.retrieve(id)
    expect(Time.parse(sub.subscription_end).to_i).to be_within(60).of(now.to_i)
  end
end