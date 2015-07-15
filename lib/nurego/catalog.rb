module Nurego

  class Catalog  < APIResource

    def self.retrieve(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, self.url(false), api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end