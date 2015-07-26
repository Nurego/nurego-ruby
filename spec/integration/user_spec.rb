require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Users" do

  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  before do
    @email = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
  end

  it "can add a user" do
    organization = Nurego::Customer.me.organization
    current_users = Nurego::User.all(organization.id)
    create_params = { password: EXAMPLE_PASSWORD, email: @email }
    user = Nurego::User.create(organization.id, create_params)
    expect(user).to be_a_kind_of(Nurego::User)
    expect(user.organization_id).to eq organization.id
    users = Nurego::User.all(organization.id)
    expect(users.count).to eq current_users.count+1
    expect(users.any? { |user| user.id == user.id }).to be_true
  end

  it "can retrieve users" do
    organization = Nurego::Customer.me.organization

    current_users = Nurego::User.all(organization.id)

    Nurego::User.create(organization.id, {email: @email, password: "1"})

    users = Nurego::User.all(organization.id)
    expect(users.count).to eq current_users.count+1

    users = Nurego::User.all(organization.id, {email: @email, status: 'active'})
    expect(users.count).to eq current_users.count+1

    users = Nurego::User.all(organization.id, {email: @email, status: 'canceled'})
    expect(users.count).to eq 0

  end

  it "can delete a user" do
    plan = Nurego::Offering.current.plans.first
    organization = Nurego::Customer.me.organization
    user = Nurego::User.create(organization.id, {email: @email, password: "1"})
    user.cancel()

    users = Nurego::User.all(organization.id, {email: @email, status: 'canceled'})
    expect(users.count).to eq 1
  end
end