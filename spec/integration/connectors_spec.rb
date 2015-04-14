require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Connectors" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can list connectors" do
    customer = Nurego::Customer.me
    organization = Nurego::Organization.retrieve(id: customer[:organization_id])
    puts "#{organization.inspect}"
    instances = organization.instances
    puts "#{instances.inspect}"
    connectors = instances.data[1].connectors
    puts "#{connectors.inspect}"
  end
end
