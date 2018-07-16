module Nurego
  class Organization < APIResource
    include Nurego::APIOperations::List
    include Nurego::APIOperations::Update
=begin
    def instances
      Instance.all({:organization => id }, @api_key)
    end
=end
    def paymentmethod
      PaymentMethod.all({:organization => id}, @api_key)
    end

    def bills
      Bill.all({ :organization => id }, @api_key)[:bills]
    end

    def subscriptions(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, url + '/subscriptions', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def users(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, url + '/users', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def feature_data(params = {}, api_key = nil)
      response, api_key = Nurego.request(:get, url + "/feature_data", api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def cancel(params = {}, api_key = nil)
      response, api_key = Nurego.request(:post, url + '/cancel', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

    def account
      Nurego::Account.retrieve(id: self[:account_no])
    end

    # params:
    
    #   :trial_days => total number of trial days
    #   :trial_months => total number of trial months
    #   exactly one of the trial_days | trial_months attributes should be passed.
    #   :plan_id => "plan guid" | plan guid
    
    def update_trial_period(params = {}, api_key = nil) 
      response, api_key = Nurego.request(:post, url + '/update_trial_period', api_key, params)
      Util.convert_to_nurego_object(response, api_key)
    end

  end
end
