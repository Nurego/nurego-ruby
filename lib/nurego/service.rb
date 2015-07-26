module Nurego

  class Service < APIResource

    def plans(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, url + '/plans', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end
