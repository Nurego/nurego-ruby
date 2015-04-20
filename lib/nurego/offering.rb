module Nurego

  class Offering < APIResource

    def self.retrieve(id, api_key = nil)
      raise NotImplementedError.new("Offering cannot be retrieved with ID. Retrieve an offering using Offering.current")
    end

    def self.current(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, self.url, api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def to_cloud_foundry_catalog
      # require BSS to expose service_id, service_name, service_description for Offering
      offering_to_broker_catalog.to_json
    end

    def plans
      Plan.all({:offering => id }, @api_key)
    end

private

    def offering_to_broker_catalog
      cf_offer = {
          offer_id: self['id'],
          offer_name: self['name'],
          offer_description: self['description'],
          services: []
      }

      # Expect single service per offering.
      cf_service = {
          # required
          id: self['service_id'],
          name: self['service_name'],
          description: self['service_description'],
          bindable: true,
          plans: []

          ## possible
          # tags: [],
          # metadata: Object,
          # requires: [],
          # plan_updateable: true,
          # dashboard_client: Object {id,secret,redirect_uri}

      }

      self['plans']['data'].each do | nurego_plan |
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
      cf_offer[:services] << cf_service # Add service to offer

      cf_offer
    end
  end
end
