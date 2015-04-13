module Nurego

  class Offering < APIResource

    def self.retrieve(id, api_key = nil)
      raise NotImplementedError.new("Offering cannot be retrieved with ID. Retrieve an offering using Offering.current")
    end

    def self.current(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, self.url, api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def self.as_cf_catalog(url, api_key )
      Nurego.api_base = url if url
      response, api_key = Nurego.request(:get, self.url, api_key, {:distribution_channel => 'cf'})
      offering_to_broker_catalog(Util.convert_to_nurego_object(response, api_key)).to_json
    end

    def plans
      Plan.all({:offering => id }, @api_key)
    end

private

    def self.offering_to_broker_catalog(nurego_offering)
      cf_offer = {
          offer_id: nurego_offering['id'],
          offer_name: nurego_offering['name'],
          offer_description: nurego_offering['description'],
          :services => []
      }

      cf_service = {
          # required
          id: nurego_offering['service_id'],
          name: nurego_offering['service_name'],
          description: nurego_offering['service_description'],
          bindable: true,
          plans: []

          ## possible
          # tags: [],
          # metadata: Object,
          # requires: [],
          # plan_updateable: true,
          # dashboard_client: Object {id,secret,redirect_uri}

      }

      nurego_offering['plans']['data'].each do | nurego_plan |
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
