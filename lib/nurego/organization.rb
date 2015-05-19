module Nurego
  class Organization < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Update

    def instances
      Instance.all({:organization => id }, @api_key)
    end

    def paymentmethod
      PaymentMethod.all({:organization => id}, @api_key)
    end

    def bills
      Bill.all({ :organization => id }, @api_key)[:bills]
    end

    def self.entitlements(params = {}, api_key = nil)
      Entitlement.all({:organization => params[:customer_id], :feature_id => params[:feature_id] }, api_key)
    end

    def entitlements(feature_id = nil)
      Entitlement.all({:organization => id, :feature_id => feature_id, :external_ids => 'false' }, @api_key)
    end

    def plan(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, url + '/plan', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def cancel(params = {}, api_key = nil)
      response, api_key = Nurego.request(:post, url + '/cancel', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end
