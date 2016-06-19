require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Entitlements" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
    Nurego.external_ids = false
  end

  it "can fetch the entitlement by organization" do
    # TODO Create real entitlements here
    # TODO 2: test using external ids too

    customer = Nurego::Customer.retrieve(@uaa_user_id)
    organization = customer.organization

    customers_ent = organization.entitlements('subscribers')

    feature_id = customers_ent[:data][0][:feature_id]

    Nurego::Entitlement.set_usage_by_organization(organization.id, feature_id, 6)

    ents =  organization.entitlements(feature_id)

    expect(ents[:data][0][:max_allowed_amount]).to be_nil
    expect(ents[:data][0][:current_used_amount]).to eq 6

    all = Nurego::Entitlement.all_by_organization(organization[:id], {}, Nurego.api_key)
  end

  it "can fetch the entitlement by subscription" do
    # TODO Create real entitlements here
    # TODO 2: test using external ids too

    customer = Nurego::Customer.retrieve(@uaa_user_id)
    subscription = customer.subscriptions.data[0]

    customers_ent = subscription.entitlements('subscribers')

    feature_id = customers_ent[:data][0][:feature_id]

    Nurego::Entitlement.set_usage(subscription.id, feature_id, 6)

    ents =  subscription.entitlements(feature_id)

    expect(ents[:data][0][:max_allowed_amount]).to be_nil
    expect(ents[:data][0][:current_used_amount]).to eq 6

    all = Nurego::Entitlement.all(subscription[:id], {}, Nurego.api_key)
  end
end