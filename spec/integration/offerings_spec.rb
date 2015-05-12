require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Offerings" do
  before(:all) do
    setup_nurego_lib(true, true) # no_register = true + public_key = true
  end

  it "can fetch current offering" do
    offering = Nurego::Offering.current
    offering["object"].should == "offering"
    offering.plans["object"].should == "list"
    offering.plans.each do |plan|
      plan["object"].should == "plan"
      plan.features.each do |feature|
        feature["object"].should == "feature"
      end
    end
  end

  it "can fetch current offering with distribution channel" do
    offering = Nurego::Offering.current({:distribution_channel => 'website'})
    offering["object"].should == "offering"

    offering.plans.each do |plan|
      plan["object"].should == "plan"
      plan.features.each do |feature|
        feature["object"].should == "feature"
      end
    end
  end

end
