module Nurego
  class Account < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Update

  end
end
