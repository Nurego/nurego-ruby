module Nurego
  module Cf
    class BrokerUtility
      def self.provision(params)
        # todo: what to return if nurego is notified ?
        return true if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        create_params = { provider: 'cloud-foundry',
                          external_subscription_id: params['instance_id'],
                          external_ids: true,
                          plan_id: params['plan_id'],
                          already_provisioned: true
        }
        Subscription.for(params['organization_guid']).create(create_params)
      end

      def self.update(params)
        # todo: what to return if nurego is notified ?
        return true if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.plan_id = params['plan_id']
        sub.save
      end

      def self.deprovision(params)
        # todo: what to return if nurego is notified ?
        return true if nurego_notified(params)
        raise InvalidRequestError.new('Invalid parameter instance_id', 'instance_id') unless params['instance_id']
        sub = Subscription.retrieve(params['instance_id'])
        sub.delete
      end

      def self.nurego_notified(params)
        params['nurego_notified'] == true
      end

      def self.get_service_catalog(service_id)
        service = Service.retrieve()
      end

    #
    # public static void deprovision(Map<String, String> params) throws NuregoException {
    #   if (!nuregoNotified(params)) {
    #     if (!params.containsKey("instance_id")) throw new InvalidRequestException("Invalid parameter instance_id", "instance_id", null);
    #       Subscription sub = Subscription.retrieve(params.get("instance_id"));
    #       sub.cancel();
    #     }
    #   }
    #
    # public static String getServiceCatalog(String serviceId) throws NuregoException {
    #   Service retrievedService = Service.retrieve(serviceId);
    #     if (retrievedService.getOfferings().getCount() == 0) return null;
    #       Offering offering = retrievedService.getOfferings().getData().get(0);
    #       JSONArray plans = new JSONArray();
    #       for (Plan plan : offering.getPlans().getData()) {
    #         JSONObject planObj = new JSONObject();
    #       planObj.put("id", plan.getId());
    #       planObj.put("name", plan.getName());
    #       planObj.put("description", plan.getDescription());
    #       Feature recurring = getRecurringFeature(plan.getFeatures().getData());
    #       planObj.put("free", !(recurring!= null && recurring.getPrice() > 0));
    #       plans.add(planObj);
    #     }
    #
    #     JSONObject service = new JSONObject();
    #     service.put("id", retrievedService.getId());
    #     service.put("name", retrievedService.getName());
    #     service.put("description", retrievedService.getDescription());
    #     service.put("bindable", true);
    #     service.put("plans", plans);
    #
    #     JSONArray services = new JSONArray();
    #     services.add(service);
    #
    #     JSONObject finalObj = new JSONObject();
    #     finalObj.put("offer_id", offering.getId());
    #     finalObj.put("offer_name", offering.getName());
    #     finalObj.put("offer_description", offering.getDescription());
    #     finalObj.put("services", services);
    #
    #     return finalObj.toString();
    #   }
    #
    # private static boolean nuregoNotified(Map<String, String> params) {
    #   return params.containsKey("nurego_notified") && params.get("nurego_notified").equals("true");
    # }
    #
    # private static Feature getRecurringFeature(List<Feature> features) {
    #   for (Feature feature : features) {
    #     if (feature.getElementType().equals("recurring")) {
    #       return feature;
    #
    #     }
    #   }
    #   return null;
    # }
    end
  end
end