require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Entitlements" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch the entitlement" do
    # TODO Create real entitlements here
    # TODO 2: test using external ids too

    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    ents = organization.entitlements(nil)

    customers_ent = organization.entitlements('subscribers')

    feature_id = customers_ent[0][:id]
    max_amount = customers_ent[0][:max_allowed_amount]
    ent = Nurego::Entitlement.new({id: organization[:id]})

    ent.set_usage(feature_id, 6, 'internal')

    allowed = ent.is_allowed({ :feature_id => feature_id, :requested_amount => 1 }, 'internal')
    expect(allowed[0][:is_allowed]).to eq true
    expect(allowed[0][:current_used_amount]).to eq 6
    expect(allowed[0][:max_allowed_amount]).to eq max_amount

    allowed = ent.is_allowed([{ :feature_id => feature_id, :requested_amount => 1 },
                              { :feature_id => feature_id, :requested_amount => 2 }],  'internal')

    expect(allowed.length).to eq 2
  end

  xit "can fetch the entitlement by external id" do
    customers_ent = Nurego::Organization.entitlements({:customer_id => 'external_id'})
  end
end