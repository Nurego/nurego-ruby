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
      Entitlement.all({:organization => id, :feature_id => feature_id, :provider_name => 'internal' }, @api_key)
    end

    def update_subscription(plan, trial = nil, coupon = nil, external_ids = true)
      params = {}
      params[:plan] = plan if plan
      params[:trial] = trial if trial
      params[:coupon] = coupon if coupon

      params[:external_ids] = external_ids
      puts "params is #{params.inspect}"
      response, api_key = Nurego.request(:put, "/v1/customers/#{id}/subscription", nil, params)
    end

  end
end
