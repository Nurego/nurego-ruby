module Nurego
  class Entitlement < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Create

    def self.set_usage(subscription_id, feature_id, amount)
      payload = {
          feature_id: feature_id,
          amount: amount,
      }
      response, api_key = Nurego.request(:post, "/v1/subscriptions/#{subscription_id}/entitlements/usage", nil, payload)
    end

    def self.set_usage_by_organization(organization_id, feature_id, amount)
      payload = {
          feature_id: feature_id,
          amount: amount,
      }
      response, api_key = Nurego.request(:post, "/v1/organizations/#{organization_id}/entitlements/usage", nil, payload)
    end

    def self.all(subscription_id, filters={}, api_key=nil)
      response, api_key = Nurego.request(:get, "/v1/subscriptions/#{subscription_id}/entitlements", api_key, filters)
      Util.convert_to_nurego_object(response, api_key)
    end

private
      def structure_sensitive_mimic_to_query(array, key)
        prefix = "#{key}[]"
        array.collect do | feature |
          feature.collect do |key, value|
            nk = "#{prefix}[#{key}]"
            "#{CGI.escape(nk)}=#{CGI.escape(value.to_s)}"
          end.sort * '&'
        end.join '&'
      end
  end
end
