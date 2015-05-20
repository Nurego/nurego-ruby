module Nurego
  class Entitlement < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Create

    def set_usage(feature_id, amount)
      payload = {
          feature_id: feature_id,
          amount: amount,
      }
      response, api_key = Nurego.request(:put, "/v1/organizations/#{id}/entitlements/usage", nil, payload)
    end

    def self.all(organization_id, filters={}, api_key=nil)
      response, api_key = Nurego.request(:get, "/v1/organizations/#{organization_id}/entitlements", api_key, filters)
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
