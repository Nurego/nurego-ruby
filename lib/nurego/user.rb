module Nurego
  class User < APIResource
    include Nurego::APIOperations::List

    # Create override
    def self.create(org_id, params={}, api_key=nil)
      response, api_key = Nurego.request(:post, url(org_id), api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    # Delete override
    def cancel(params={})
      # use params to pass extra parameters to Nurego backend
      response, api_key = Nurego.request(:delete, url(self.organization_id), @api_key, params)
      refresh_from(response, api_key)
      self
    end

    def self.all(org_id, params={}, api_key=nil)
      response, api_key = Nurego.request(:get, self.url(org_id), api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    # override class url
    def self.url(org_id = nil)
      return super() unless org_id
      "/v1/organizations/#{CGI.escape(org_id)}/#{CGI.escape(class_name.downcase)}s"
    end

    # override instance url
    def url(org_id = nil)
      return super() unless org_id
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has no ID: #{self.inspect}", 'id')
      end
      "#{self.class.url(org_id)}/#{CGI.escape(id)}"
    end

  end
end
