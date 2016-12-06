require File.join(File.dirname(__FILE__), 'spec_helper')
describe "Broker Utility" do

  before(:all) do
    setup_nurego_lib
    setup_login_and_login
    Nurego::Cf::BrokerUtility.external_ids = false
    @test_instance_id = SecureRandom.uuid
  end

  it "doesn't notify on provision requests from proxy" do
    # mocked incoming provision params from nurego-cf-proxy
    provision_params = {
        'nurego_notified' => true,
        'instance_id' => @test_instance_id,
        'plan_id' => Nurego::Offering.current.plans.first.id,
        'organization_guid' => Nurego::Customer.retrieve(@uaa_user_id).organization.id,
        'service_id' => 'some_service_id',
        'space_guid' => 'some_space_guid'
    }
    current_subscriptions = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    sub = Nurego::Cf::BrokerUtility.provision(provision_params)
    expect(sub).to be_nil
    my_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    expect(my_subs.count).to eq current_subscriptions.count
  end

  it "notifies on provision request" do
    # catch requests
    original_exec_req = Nurego.method(:execute_request)
    allow(Nurego).to receive(:execute_request) do |opts|
      @request_opts = opts
      original_exec_req.call(opts)
    end
    # mocked incoming provision params from cli
    provision_params = {
        'instance_id' => @test_instance_id,
        'plan_id' => Nurego::Offering.current.plans.first.id,
        'organization_guid' => Nurego::Customer.retrieve(@uaa_user_id).organization.id,
        'service_id' => 'some_service_id',
        'space_guid' => 'some_space_guid'
    }
    # call the BrokerUtility
    sub = Nurego::Cf::BrokerUtility.provision(provision_params)
    # Save the outgoing request
    request = @request_opts
    # Checks
    my_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    expect(my_subs.any? { |subscription| subscription.id == sub.id }).to be_true
    expect(request[:method]).to eq :post
    expect(request[:url]).to eq "#{Nurego.api_base}/v1/organizations/#{ provision_params['organization_guid'] }/subscriptions"
    payload = Nurego::JSON.load(request[:payload])
    expect(payload['external_subscription_id']).to eq "#{ provision_params['instance_id'] }"
    expect(payload['provider']).to eq 'cloud-foundry'
    expect(payload['skip_service_webhook']).to eq true
    expect(payload['plan_id']).to eq "#{ provision_params['plan_id'] }"
  end

  it "notifies on subscription update" do
    # catch requests
    original_exec_req = Nurego.method(:execute_request)
    allow(Nurego).to receive(:execute_request) do |opts|
      @request_opts = opts
      original_exec_req.call(opts)
    end
    # mocked incoming update params
    update_params = {
        'instance_id' => @test_instance_id,
        'plan_id' => Nurego::Offering.current.plans.data[1].id
    }
    orig_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    # call the BrokerUtility
    sub = Nurego::Cf::BrokerUtility.update(update_params)
    # Save the outgoing request
    request = @request_opts
    # Checks
    my_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    expect(my_subs.any? { |subscription| subscription.id == sub.id }).to be_true
    expect(orig_subs.any? { |subscription| subscription.id == sub.id }).to be_false
    expect(my_subs.find{|item| item.id == sub.id}.plan.id).to eq update_params['plan_id']
    expect(request[:method]).to eq :put
    expect(request[:url]).to eq "#{Nurego.api_base}/v1/organizations/#{ Nurego::Customer.retrieve(@uaa_user_id).organization.id }/subscriptions/#{ orig_subs.find{|item| !my_subs.any?{|item2| item2.id == item.id}}.id }"
    payload = Nurego::JSON.load(request[:payload])
    # expect(payload['external_subscription_id']).to eq "#{ provision_params['instance_id'] }"
    expect(payload['provider']).to eq 'cloud-foundry'
    expect(payload['skip_service_webhook']).to eq true
    # expect(payload['external_ids']).to eq 'false'
    expect(payload['plan_id']).to eq "#{ update_params['plan_id'] }"
  end

  it "notifies on subscription cancellation" do
    # catch requests
    original_exec_req = Nurego.method(:execute_request)
    allow(Nurego).to receive(:execute_request) do |opts|
      @request_opts = opts
      original_exec_req.call(opts)
    end
    # mocked incoming deprovision params
    deprovision_params = {
        'instance_id' => @test_instance_id,
        'plan_id' => Nurego::Offering.current.plans.data[0].id,
        'service_id' => 'Some_service_id'
    }
    orig_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    sub_id = Nurego::Subscription.retrieve(@test_instance_id).id
    # call the BrokerUtility
    sub = Nurego::Cf::BrokerUtility.deprovision(deprovision_params)
    # Save the outgoing request
    request = @request_opts
    # Checks
    my_subs = Nurego::Customer.retrieve(@uaa_user_id).subscriptions.data
    expect(my_subs.any? { |subscription| subscription.id == sub_id }).to be_false
    expect(orig_subs.any? { |subscription| subscription.id == sub_id }).to be_true
    expect(orig_subs.find{|item| !my_subs.any?{|item2| item2.id == item.id}}.id).to eq sub_id
    expect(request[:method]).to eq :delete
    url = request[:url].split('?')
    expect(url[0]).to eq "#{Nurego.api_base}/v1/organizations/#{ Nurego::Customer.retrieve(@uaa_user_id).organization.id }/subscriptions/#{ sub_id }"
    payload = {}
    url[1].split('&').each {|item| key,value = item.split('='); payload[key] = value;}
    expect(payload['provider']).to eq 'cloud-foundry'
    expect(payload['skip_service_webhook']).to eq 'true'
  end


  it "can parse service offering to cloud foundry catalog" do
    offer_as_catalog = Nurego::Cf::BrokerUtility.get_service_catalog(SERVICE_ID)
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
        expect(plan['description']).to match /[^\s]/
      end
    end
  end
end