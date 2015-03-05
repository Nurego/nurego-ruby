require File.join(File.dirname(__FILE__), 'spec_helper')

describe "LegalDocs" do
  before(:all) do
    setup_nurego_lib(true)
#    Nurego.api_key = 'lp472a7d-bea0-47f6-a9d7-54ec52263aed'
  end

  it "can fetch default document" do
    doc = Nurego::LegalDoc.retrieve
#    puts doc.inspect
    if doc["object"]
      doc['object'].should == "legal_doc"
      doc['id'].should_not be_nil
    end
  end

  it "will raise error when trying to retrieve by id" do
    expect{Nurego::LegalDoc.retrieve('id')}.to raise_exception
  end

  it "can fetch doc with distribution channel" do
    doc = Nurego::LegalDoc.retrieve({:distribution_channel => 'website'})
    if doc["object"]
      doc['object'].should == "legal_doc"
      doc['id'].should_not be_nil
    end
  end

end
