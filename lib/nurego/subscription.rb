module Nurego
  class Subscription < APIResource
    # include Nurego::APIOperations::Create
    include Nurego::APIOperations::Update
    # include Nurego::APIOperations::Delete

    # Create override
    def self.create(org_id, params={}, api_key=nil)
      response, api_key = Nurego.request(:post, self.url(org_id), api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    # Update override
    def save
      values = serialize_params(self)

      if values.length > 0
        values.delete(:id)

        response, api_key = Nurego.request(:post, url(self.organization_id), @api_key, values)
        refresh_from(response, api_key)
      end
      self
    end

    # Delete override
    def delete
      response, api_key = Nurego.request(:delete, url(self.organization_id), @api_key)
      refresh_from(response, api_key)
      self
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
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url(org_id)}/#{CGI.escape(id)}"
    end

  end
end
