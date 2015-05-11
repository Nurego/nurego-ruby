module Nurego
  class Registration < APIResource
    include Nurego::APIOperations::Create
    include Nurego::APIOperations::List

    def complete(params)
      response, api_key = Nurego.request(:post, complete_url, @api_key, params)
      refresh_from({customer: response}, api_key, true)
      customer
    end

    def self.find_by_external_id(external_id, params = { })
      response, api_key = Nurego.request(:get, find_by_external_id_url(external_id), @api_key, params)
      response
    end

    private
    def self.find_by_external_id_url(external_id)
      url + "?instance_id=#{ external_id }"
    end

    def complete_url
      url + '/complete'
    end
  end
end
