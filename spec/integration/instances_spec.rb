require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Instances" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  xit "can retrieve instances" do
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    organization = customer.organization
    instances = organization.instances
    instances.count.should == 2
    instances.each do |instance|
      instance["object"] == "instance"
    end
  end

  xit "can retrieve connectors" do
    # PENDING on connector fix
    # TODO create real connector and fetch it
    customer = Nurego::Customer.retrieve(@uaa_user_id)
    organization = customer.organization
    instances = organization.instances
    instances.count.should == 2
    instances.each do |instance|
      connectors = instance.connectors
      connectors.each do |connector|
        connector["object"].should == "connector"
      end
    end
  end
end