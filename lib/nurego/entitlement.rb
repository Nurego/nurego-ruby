require 'rack'

module Nurego
  class Entitlement < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Create

    def set_usage(feature_id, amount, provider_name = nil)
      payload = {
          feature_id: feature_id,
          organization: id,
          amount: amount,
      }
      payload[:provider_name] = provider_name if provider_name
      response, api_key = Nurego.request(:put, "/v1/entitlements/usage", nil, payload)
    end

    def is_allowed(features, provider_name = nil)
      payload =  {
          :organization => id,
      }
      payload[:provider_name] = provider_name if provider_name

      features = features.is_a?(Array) ? features : [features]
      features_url = structure_sensitive_mimic_to_query(features, 'features')
      response, api_key = Nurego.request(:get, "/v1/entitlements/allowed?#{features_url}",
                                         nil, payload)
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
