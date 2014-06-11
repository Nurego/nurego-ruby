require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Entitlements" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch the entitlement" do
    # TODO Create a real entitlements here

    customer = Nurego::Customer.me
    organization = customer.organizations[0]
    # TODO(mweaver): Support internal id's in the entitlements API. New
    # organizations do not have a external id (for good reason).
    pending('Support for internal org id in the entitlements API')
    ents = organization.entitlements(nil, organization[:id])

    customers_ent = organization.entitlements('subscribers')

    feature_id = customers_ent[0][:id]
    max_amount = customers_ent[0][:max_allowed_amount]
    ent = Nurego::Entitlement.new({id: organization[:id]})

    ent.set_usage(feature_id, max_amount - 1)

    allowed = ent.is_allowed(feature_id, 1)
    puts "#{allowed.inspect}"

    allowed = ent.is_allowed(feature_id, 2)
    puts "#{allowed.inspect}"
  end
end