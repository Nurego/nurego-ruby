module Nurego
  module Cf
    class BrokerUtility
      PROVIDER = 'cloud-foundry'
      @external_ids = true

      class << self
        attr_accessor :external_ids
      end

      def self.provision(params)
        return nil if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        create_params = { provider: PROVIDER,
                          external_subscription_id: params['instance_id'],
                          plan_id: params['plan_id'],
                          skip_service_webhook: true
        }
        Subscription.create(params['organization_guid'], create_params)
      end

      def self.update(params)
        return nil if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.plan_id = params['plan_id']
        sub.provider = PROVIDER
        sub.skip_service_webhook = true
        sub.save
      end

      def self.deprovision(params)
        return nil if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.cancel({ provider: PROVIDER, skip_service_webhook: true })
      end

      def self.nurego_notified(params)
        params['nurego_notified'] == true
      end

      def self.get_service_catalog(service_id)
        service = Service.retrieve(service_id)
        plans = service.plans
        service_to_cloud_foundry_catalog(service, plans)
      end

      private

      def self.service_to_cloud_foundry_catalog(service, plans)
        cf_catalog = { services: [] }
        cf_service = {
            # required
            id: service['id'],
            name: service['name'],
            description: service['description'],
            bindable: true,
            plans: []

            ## possible
            # tags: [],
            # metadata: Object,
            # requires: [],
            # plan_updateable: true,
            # dashboard_client: Object {id,secret,redirect_uri}

        }
        plans.each do | nurego_plan |
          cf_plan = {
            # required
            id: nurego_plan['id'],
            name: nurego_plan['name'],
            description: nurego_plan['description'] || nurego_plan['name'],

            ## possible
            # metadata: Object,
            # free: true,
          }


          recurring = nurego_plan['features']['data'].find { | feature | feature['element_type'] == 'recurring' }
          cf_plan[:free] = !(recurring && recurring['price'] > 0)

          cf_service[:plans] << cf_plan # Add plans to the service
        end
        cf_catalog[:services] << cf_service # Add service to offer

        cf_catalog.to_json
      end

    end
  end
end