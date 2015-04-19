require 'uuidtools'
require_relative "../../lib/nurego"

EXAMPLE_EMAIL = "integration.test+#{UUIDTools::UUID.random_create.to_s}@openskymarkets.com"
EXAMPLE_PASSWORD = "password"

def setup_nurego_lib(no_register = false, public_key = false)
  Nurego.api_base = ENV['API_BASE'] || "http://localhost:31001"
  if public_key
    Nurego.api_key = ENV['NUREGO_PUBLIC_API_KEY_TEST'] || 'tpa212f0-4f66-48f1-9de0-af5f931621ec'
  else
    Nurego.api_key = ENV['NUREGO_API_KEY_TEST'] || 'tee00d77-d6f2-4f8d-8897-26fb89fbeb34'
  end

  register unless no_register
end

def setup_login_and_login(no_login = false)
  Nurego::Auth.client_id = "portal"
  Nurego::Auth.client_secret = ENV['PORTALSECRET'] || "portalsecret"
  Nurego::Auth.provider_site = ENV['UAA_URL'] || "http://localhost:8080/uaa"

  Nurego::Auth.login(EXAMPLE_EMAIL, EXAMPLE_PASSWORD) unless no_login
end

def register
  return if ENV['CUSTOMER_SET'] == "yes"

  Nurego::Auth.logout
  registration = Nurego::Registration.create({email: EXAMPLE_EMAIL})
  customer = registration.complete(id: registration.id, password: EXAMPLE_PASSWORD)
  ENV['CUSTOMER_SET'] = (customer["email"] == EXAMPLE_EMAIL && customer["object"] == "customer") ? "yes" : "no"
end