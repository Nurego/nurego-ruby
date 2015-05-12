require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Registrations" do
  before(:all) do
    setup_nurego_lib(true)
    Nurego::Auth.logout
  end

  before do
    @email = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
  end

  context "registration complete" do
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

  context "find registration by external id" do
    it "returns registration when single external instance id found" do
      guid = SecureRandom.uuid
      registration = Nurego::Registration.create({ instance_id: guid, provider: 'unit-test' })
      expect(registration).to be_an_instance_of Nurego::Registration
      expect(registration.id).not_to be_nil
      expected_registration = registration.id
      registration = Nurego::Registration.find_by_external_id(guid)
      expect(registration.id).to eq expected_registration
    end

    it "returns a bad request when multiple external instance id found" do
      Nurego::Registration.create({ instance_id: 'duplicated_external_instance_id_test', provider: 'unit-test' })
      Nurego::Registration.create({ instance_id: 'duplicated_external_instance_id_test', provider: 'another-test-provider' })
      begin
        Nurego::Registration.find_by_external_id('duplicated_external_instance_id_test')
      rescue Nurego::InvalidRequestError => e
        e.http_status.should eq(400)
        !!e.http_body.should(be_true)
        !!e.json_body[:error][:message].should(be_true)
        e.json_body[:error][:message].should eq("Invalid request: \"Found multiple registrations for external instance is: duplicated_external_instance_id_test\"")
      end
    end

    it "returns a 404 when no external instance id found" do
      begin
        Nurego::Registration.find_by_external_id('no_external_instance_id_exist')
      rescue Nurego::InvalidRequestError => e
        e.http_status.should eq(404)
        !!e.http_body.should(be_true)
        !!e.json_body[:error][:message].should(be_true)
        e.json_body[:error][:message].should eq("Route /v1/registrations?instance_id=no_external_instance_id_exist not found")
      end
    end
  end
end
