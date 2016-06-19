module Nurego
  class Customer < APIResource
    include Nurego::APIOperations::List

    def organization
      Nurego::Organization.retrieve(id: self[:organization_id])
    end

  end
end
