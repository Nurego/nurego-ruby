require File.join(File.dirname(__FILE__), '../spec/integration/spec_helper')

begin
    setup_nurego_lib(true,false)
    setup_login_and_login(true)
    @email = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"




    # retrieve catalog
    catalog  = Nurego::Catalog.retrieve()
    puts "Retrieve a catalog:\n" ,catalog[:data]

    #retrieve service by guid
    service = Nurego::Service.retrieve(catalog[:data][0][:services][:data][0][:id])
    puts "Retrieve a service by guid:\n" , service , "\n"

    # retrieve current offering
    current_offering = Nurego::Offering.current
    puts "Retrieve the current offering:\n" , current_offering , "\n"

    #retrieve offering by dist channel & segment
    params = Hash.new
    params[:distribution_channel] = 'website'
    params[:segment_guid] = 'seg_7c77-8800-4fe6-9ced-6ce886ce2438'
    offering  = Nurego::Offering.current(params)
    puts "Retrieve an offering:\n" , offering , "\n"

    # register
    registration = Nurego::Registration.create({email: @email})
    puts "Register:\n" , registration , "\n"
    customer = registration.complete(id: registration.id, password: EXAMPLE_PASSWORD)

    #retrieve logged in user
    Nurego::Auth.login(customer["email"], EXAMPLE_PASSWORD)
    retrieved_customer = Nurego::Customer.me
    puts "Retrieve customer details:\n" , retrieved_customer , "\n"

    org_id = retrieved_customer.organization_id
    org = Nurego::Organization.retrieve(org_id)
    puts "Retrieve an organization by guid:\n" , org , "\n"

    entitlements = Nurego::Entitlement.all(org_id)
    puts "Retrieve entitlements by organization guid\n" , entitlements, "\n"

    #create a new subscription
    params = {}
    params[:plan_id] = current_offering.plans[:data][2][:id]
    sub = Nurego::Subscription.create(org_id, params)

    puts "The newly creation subscription:\n" , sub, "\n"
    puts "The Customer subscription:\n", Nurego::Customer.me.subscriptions , "\n"


    #update subscription plan
    newplan = current_offering.plans[:data][3][:id]
    updatedsub = Nurego::Subscription.update(org_id,sub.id,newplan)
    puts "The Customer subscription (notice the plan update):\n", Nurego::Customer.me.subscriptions , "\n"

    #cancel subscription
    updatedsub.cancel
    puts "The Customer subscription (notice end date:\n", Nurego::Customer.me.subscriptions , "\n"

    # update usage
    entitlement = org.entitlements.first
    Nurego::Entitlement.set_usage(org_id,entitlement.id, 13)
    puts "Notice the usage of #{entitlement.id} is now set to 13:\n", Nurego::Organization.retrieve(org_id).entitlements.first, "\n"



  end




