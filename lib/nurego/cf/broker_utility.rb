module Nurego
  module Cf
    class BrokerUtility

      @external_ids = true

      class << self
        attr_accessor :external_ids
      end

      def self.provision(params)
        # todo: what to return if nurego is notified ?
        return nil if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        create_params = { provider: 'cloud-foundry',
                          external_subscription_id: params['instance_id'],
                          external_ids: @external_ids,
                          plan_id: params['plan_id'],
                          skip_service_webhook: true
        }
        Subscription.create(params['organization_guid'], create_params)
      end

      def self.update(params)
        # todo: what to return if nurego is notified ?
        return true if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.plan_id = params['plan_id']
        sub.provider = 'cloud-foundry'
        sub.skip_service_webhook = true
        sub.save
      end

      def self.deprovision(params)
        # todo: what to return if nurego is notified ?
        return true if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.delete({ provider: 'cloud-foundry', skip_service_webhook: true })
      end

      def self.nurego_notified(params)
        params['nurego_notified'] == true
      end

      def self.get_service_catalog(service_id)
        service = Service.retrieve(service_id)
        service_to_cloud_foundry_catalog(service)
      end

      private

      def self.service_to_cloud_foundry_catalog(service)
        cf_catalog = {
            offer_id: service.offerings.first['id'],
            offer_name: service.offerings.first['name'],
            offer_description: service.offerings.first['description'],
            services: []
        }
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
        service.offerings.first['plans']['data'].each do | nurego_plan |
          cf_plan = {
              # required
              id: nurego_plan['id'],
              name: nurego_plan['name'],
              description: nurego_plan['description'],

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