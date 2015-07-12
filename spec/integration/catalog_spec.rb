require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Catalog" do
  before(:all) do
    setup_nurego_lib
    setup_login_and_login
  end

  it "can fetch catalog" do
    catalog  = Nurego::Catalog.retrieve()

    catalog["object"].should == "list"
    catalog["count"].should == 1
  end


end
