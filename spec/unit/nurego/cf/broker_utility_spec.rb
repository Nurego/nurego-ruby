require File.expand_path('../../../test_helper', __FILE__)
describe Nurego::Cf::BrokerUtility do

  before(:each) do
    @mock = double
    Nurego.mock_rest_client = @mock
    Nurego.api_key="foo"
  end

  it "can parse service offering to cloud foundry catalog" do
    @mock.should_receive(:get).and_return(test_response(test_service_without_offering))
    offer_as_catalog = Nurego::Cf::BrokerUtility.get_service_catalog("testservice")
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

      plans.each do |plan|
        expect(plan.keys.length).to be >= 3
        expect(plan.keys).to include("id")
        expect(plan.keys).to include("name")
        expect(plan.keys).to include("description")
        expect(plan['description']).not_to be_nil
      end
    end
  end



end