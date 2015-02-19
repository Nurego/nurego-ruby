require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Registrations" do
  before(:all) do

    setup_nurego_lib(true)
  end

  before do
    @email = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
  end

  it "can register a subscriber" do
    registration = Nurego::Registration.create({email: @email})
    customer = registration.complete(id: registration.id, password: EXAMPLE_PASSWORD)
    customer["email"].should == @email
    customer["object"].should == "customer"
  end

  it "can register a subscriber providing email only on complete" do
    registration = Nurego::Registration.create()
    customer = registration.complete(id: registration.id, password: EXAMPLE_PASSWORD, email: @email)
    customer["email"].should == @email
    customer["object"].should == "customer"
  end
end
