require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Entitlements" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
    Nurego.external_ids = false
  end

  it "can fetch the entitlement" do
    # TODO Create real entitlements here
    # TODO 2: test using external ids too

    customer = Nurego::Customer.me
    organization = customer.organization
    ents = organization.entitlements(nil)

    customers_ent = organization.entitlements('subscribers')

    feature_id = customers_ent[:data][0][:id]
    max_amount = customers_ent[:data][0][:max_allowed_amount]
    ent = Nurego::Entitlement.new({id: organization[:id]})

    ent.set_usage(feature_id, 6)

    allowed =  organization.entitlements(feature_id)

    expect(allowed[:data][0][:max_allowed_amount] >= allowed[:data][0][:current_used_amount] + 1).to eq true
    expect(allowed[:data][0][:current_used_amount]).to eq 6
    expect(allowed[:data][0][:max_allowed_amount]).to eq max_amount

    all = Nurego::Entitlement.all({:organization => organization[:id] }, Nurego.api_key)
  end
end