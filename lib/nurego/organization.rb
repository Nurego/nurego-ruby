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

    def entitlements(provider_name, feature_id = nil)
      Entitlement.all({:organization => id, :feature_id => feature_id, :provider_name => provider_name }, @api_key)
    end

  end
end
