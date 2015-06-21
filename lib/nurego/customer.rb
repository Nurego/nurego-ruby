module Nurego
  class Customer < APIResource
    include Nurego::APIOperations::List

    def self.me(api_key = nil)
      response, api_key = Nurego.request(:get, me_url, api_key)
      Util.convert_to_nurego_object(response, api_key)
    end

    def organization
      Nurego::Organization.retrieve(id: self[:organization_id])
    end

    def self.me_url
      '/v1/customers/me'
    end

    def self.update_plan(plan_id, sub_id)
      response, api_key = Nurego.request(:post, "/v1/customers/subscriptions/#{CGI.escape(sub_id)}", nil, { :plan_id => plan_id })
      Util.convert_to_nurego_object(response, api_key)
    end

    def self.cancel_account
      response, api_key = Nurego.request(:put, "/v1/customers/cancel", nil)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end
