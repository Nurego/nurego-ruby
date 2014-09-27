require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Offerings" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch current offering" do
    offering = Nurego::Offering.current
    offering["object"].should == "offering"

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

  it "can fetch the plans from offering" do
    offering = Nurego::Offering.current
    plans = offering.plans
    plans["object"].should == "list"

    plans.each do |plan|
      plan["object"].should == "plan"
      plan.features.each do |feature|
        feature["object"].should == "feature"
      end
    end
  end

  xit "can fetch my current plan" do
    plan = Nurego::Offering.my_plan({:customer_id => 'cus_4pgBgi7RgqjWX4'})
    plan["object"].should == "plan"
  end
end
