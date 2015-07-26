require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Services" do
  before(:all) do
    setup_nurego_lib(true, true) # no_register = true + public_key = true
  end

  it "can fetch a service " do
    service = Nurego::Service.retrieve(SERVICE_ID)
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
    service = Nurego::Service.retrieve({ id:SERVICE_ID, distribution_channel:'website' })
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

  it "can fetch service plans" do
    service = Nurego::Service.retrieve(SERVICE_ID)
    plans = service.plans
    plans['object'].should == "list"
    plans['count'].should be >0
    plans['data'].should be_a_kind_of(Array)
    plans['data'].size.should eq plans["count"]
    plans['data'].each do |plan|
      plan["object"].should == "plan"
      plan.features.each do |feature|
        feature["object"].should == "feature"
      end
    end
  end

end
