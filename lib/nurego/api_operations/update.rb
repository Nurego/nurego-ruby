module Nurego
  module APIOperations
    module Update
      def save(request_type = 'post')
        values = serialize_params(self)

        if values.length > 0
          values.delete(:id)

          response, api_key = Nurego.request(request_type.to_sym, url, @api_key, values)
          refresh_from(response, api_key)
        end
        self
      end

      def update
        self.save('put')
      end

      def serialize_params(obj, force = false)
        case obj
        when nil
          ''
        when NuregoObject
          unsaved_keys = force ? obj.instance_variable_get(:@values).keys : obj.instance_variable_get(:@unsaved_values)
          obj_values = obj.instance_variable_get(:@values)
          update_hash = {}

          unsaved_keys.each do |k|
            update_hash[k] = serialize_params(obj_values[k], true)
          end

          update_hash
        else
          obj
        end
      end
    end
  end
end
