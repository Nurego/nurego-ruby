Overview


Nurego-Ruby is simple Ruby bindings library allows easy access to Nurego system, without any hassle of dealing with REST APIs and object mapping. Each object in the system has its own Ruby representation. There are relationships between some of them and they can be traversed using Nurego-Ruby API. The following objects can be used by the customers of Nurego-Ruby:
Bill
Connector
Customer
Entitlement
Feature
Instance
Offering
Organization
Password Reset
Payment Method
Plan
Registration
Some of the objects allow simple CRUD (or subset of it), when the others hide more complex operations like password reset. 

Initialization

require “nurego”
Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”

Your API key can be obtained from Settings/Organization
Authorization


Some of the operations require customer login (TBD)

Error handling


Several errors can be thrown by the library. The base class for all Nurego errors is Nurego::NuregoError

Additional error that can be thrown by the library are:

Nurego::APIConnectionError - failed to connect to the Nurego API endpoing
Nurego::APIErrror - bad response from API endpoint
Nurego::CardError - invalid token was provided
Nurego::UserNotFoundError - user not found
Nurego::InvalidRequestError - the request to the API endpoint was bad or had wrong arguments
Nurego::AuthenticationError - bad API key or username/password was provided

Entitlement


To use an entitlement object you need to obtain customer external ID. In case of Stripe it will be Stripe customer ID (guid starting with cus_

Get entitlement for customer
﻿﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”

Nurego.login(username, password)



customer = Nurego::Customer.me
  organization = customer.organizations[0]
  ents = organization.entitlements(nil, customer_id)
rescue Nurego::NuregoError => e
  puts “Got exception #{e}”
end

﻿[#<Nurego::NuregoObject:0x18b83b8> JSON: {
 "id": "dba33a54-57dc-4a29-abf7-0a83aa7c1961",
 "object": "entitlement",
 "feature_name": "subscribers",
 "max_allowed_amount": 10
}]

Get entitlements for customer and feature
﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”

Nurego.login(username, password)



customer = Nurego::Customer.me
  organization = customer.organizations[0]
  ents = organization.entitlements(feature_id, customer_id)
rescue Nurego::NuregoError => e
  puts “Got exception #{e}”



end


Submit usage for customer
﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”

Nurego.login(username, password)



ent = Nurego::Entitlement.new({id: customer_id})
  ent.set_usage(feature_id, max_amount - 1)
rescue Nurego::NuregoError => e
  puts “Got exception #{e}”
end


Check allowed usage for customer
﻿﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”

Nurego.login(username, password)



customer = Nurego::Customer.me
  organization = customer.organizations[0]
  ents = organization.entitlements(feature_id, customer_id)
  ent = ents[0]



allowed = ent.is_allowed(feature_id, 1)
  puts "#{allowed.inspect}"



allowed = ent.is_allowed(feature_id, 2)
  puts "#{allowed.inspect}"
rescue Nurego::NuregoError => e
  puts “Got exception #{e}”
end

Feature

﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”
  offering = Nurego::Offering.current
  offering.plans.each do |plan|
  puts plan.inspect
  plan.features.each do |feature|
    puts feature.inspect
  end
end

Response will look like this
﻿#<Nurego::Feature:0x1285518> JSON: {
 "id": "id",
  "object": "feature",
  "name": "Funds Service",
  "element_type": "feature",
  "price": 0.0,
  "min_unit": 0,
  "max_unit": 0,
  "period": "monthly",
  "billing_period_interval": 1,
  "unit_type": {"name":"Funds Service","consumable":false,"apply_repetition":0,"guid":"cd96f327-e1e1-4081-8717-a5baaae4984e"}
}
Offering

Retrieve the current offering for the 'All' segment through the 'website' distribution channel.
﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”
  offering = Nurego::Offering.current
  puts offering.inspect
end

To retrieve offerings available for a particular segment and/or distribution channel, add the optional :segment_guid and/or :distribution_channel parameters. To learn more about segments and distribution channels, take a look at the documentation
﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”
  offering = Nurego::Offering.current({:segment_guid => '<SEGMENT>', :distribution_channel => '<CHANNEL>'})
  puts offering.inspect
end
﻿Response will look like this
﻿#<Nurego::ListObject:0x1412db8> JSON: {
"data": [
{
  "id": "ce24d45f-4b33-41d3-a3cb-d46ad411c086",
  "object": "plan",
  "name": "Entry Level",
  "description": null,
  "plan_status": "active",
  "credit_card": false,
  "plan_order": 0,
  "discounts": [

],
  "features": {
    "data": [
      {
        "id": "id",
        "object": "feature",
        "name": "Email Support",
        "element_type": "feature",
        "price": 0,
        "min_unit": 0,
        "max_unit": 0,
        "period": "monthly",
        "billing_period_interval": 1,
        "unit_type": {
          "name": "Email Support",
          "consumable": false,
          "apply_repetition": 0,
          "guid": "dba33a54-57dc-4a29-abf7-0a83aa7c1961"
        }
      },
      {
        "id": "id",
        "object": "feature",
        "name": "Financial News Service",
        "element_type": "feature",
        "price": 0,
        "min_unit": 0,
        "max_unit": 0,
        "period": "monthly",
        "billing_period_interval": 1,
        "unit_type": {
          "name": "Financial News Service",
          "consumable": false,
          "apply_repetition": 0,
          "guid": "7de73a31-db39-4aa7-a8c2-8c1d325ec080"
        }
      },
      {
        "id": "id",
        "object": "feature",
        "name": "Indices Services",
        "element_type": "feature",
        "price": 0,
        "min_unit": 0,
        "max_unit": 2,
        "period": "monthly",
        "billing_period_interval": 1,
        "unit_type": {
          "name": "Indices Services",
          "consumable": false,
          "apply_repetition": 0,
          "guid": "65531b5f-a1af-474e-8709-65f49b6c6ad8"
        }
      },
      {
        "id": "id",
        "object": "feature",
        "name": "recurring",
        "element_type": "recurring",
        "price": 0,
        "min_unit": 0,
        "max_unit": 0,
        "period": "monthly",
        "billing_period_interval": 1
      }
    ],
    "object": "list",
    "count": 4,
    "url": "\/v1\/plans\/ce24d45f-4b33-41d3-a3cb-d46ad411c086\/features"
  }
}
],
  "object": "list",
  "count": 1,
  "url": "/v1/offerings/013ddd26-131d-43f9-95e3-790111a91dad/plans"
}

Plan

﻿The :distribution_channel and :segment_guid params are optional. Use them to call plans for a specific distribution channel and/or segment. To learn more about creating segments and distribution channels, check out the documentation
﻿begin
  Nurego.api_key = “l230bc7b-9b85-4c5f-ad9f-4eeeef4d4f44”
  offering = Nurego::Offering.current({:segment_guid => '<SEGMENT>', :distribution_channel => '<CHANNEL>'})

offering.plans.each do |plan|
    puts plan.inspect
  end
end
