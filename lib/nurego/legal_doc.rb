module Nurego
  class LegalDoc < APIResource

    def self.retrieve(params = {}, api_key = nil)
      raise NotImplementedError.new("Docs cannot be retrieved with ID. Retrieve a legal document using search parameters") if
          !params.is_a?(Hash)  || params[:id]

      response, api_key = Nurego.request(:get, self.url, api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end
