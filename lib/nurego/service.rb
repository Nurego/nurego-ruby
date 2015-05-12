module Nurego

  class Service < APIResource

    def to_cloud_foundry_catalog
      service_to_cloud_foundry_catalog.to_json
    end

    private

    def service_to_cloud_foundry_catalog
      cf_catalog = {
          offer_id: self.offerings.first['id'],
          offer_name: self.offerings.first['name'],
          offer_description: self.offerings.first['description'],
          services: []
      }
      cf_service = {
          # required
          id: self['id'],
          name: self['name'],
          description: self['description'],
          bindable: true,
          plans: []

          ## possible
          # tags: [],
          # metadata: Object,
          # requires: [],
          # plan_updateable: true,
          # dashboard_client: Object {id,secret,redirect_uri}

      }
      self.offerings.first['plans']['data'].each do | nurego_plan |
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

      cf_catalog
    end
  end
end
