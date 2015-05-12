require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Services" do
  before(:all) do
    setup_nurego_lib(true, true) # no_register = true + public_key = true
  end

  it "can fetch a service " do
    service = Nurego::Service.retrieve("197f9207-7325-4d75-983a-116b43fb9cc8")
    service["object"].should == "service"
    service.offerings["object"].should == "list"
    service.offerings.each do |offering|
      offering.plans["object"].should == "list"
      offering.plans.each do |plan|
        plan["object"].should == "plan"
        plan.features.each do |feature|
          feature["object"].should == "feature"
        end
      end
    end
  end

  it "can fetch service with distribution channel" do
    service = Nurego::Service.retrieve({ id:'197f9207-7325-4d75-983a-116b43fb9cc8', distribution_channel:'website' })
    service["object"].should == "service"
    service.offerings["object"].should == "list"
    service.offerings.each do |offering|
      offering.plans["object"].should == "list"
      offering.plans.each do |plan|
        plan["object"].should == "plan"
        plan.features.each do |feature|
          feature["object"].should == "feature"
        end
      end
    end
  end

  it "can parse service offering to cloud foundry catalog" do
    service = Nurego::Service.retrieve("197f9207-7325-4d75-983a-116b43fb9cc8")
    offer_as_catalog = service.to_cloud_foundry_catalog
    response_json = JSON.parse offer_as_catalog

    expect(response_json.keys).to include("services")

    services = response_json["services"]
    expect(services.length).to be > 0

    services.each do |service|
      expect(service.keys.length).to be >= 5
      expect(service.keys).to include("id")
      expect(service.keys).to include("name")
      expect(service.keys).to include("description")
      expect(service.keys).to include("bindable")
      expect(service.keys).to include("plans")

      plans = service["plans"]
      expect(service.keys.length).to be >= 5

      expect(plans.length).to be > 0
      plans.each do |plan|
        expect(plan.keys.length).to be >= 3
        expect(plan.keys).to include("id")
        expect(plan.keys).to include("name")
        expect(plan.keys).to include("description")
      end
    end
  end
end
