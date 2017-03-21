require 'uri'
require 'puppet/parameter/boolean'
require_relative './foremanapi_common'

Puppet::Type.newtype(:foremanapi_settings_auth) do
  @doc = 'Manage a foreman server auth settings.'

  include ForemanApi_Common

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:authorize_login_delegation, :boolean => true) do
    desc 'Authorize login delegation with REMOTE_USER environment variable'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:authorize_login_delegation_api, :boolean => true) do
    desc 'Authorize login delegation with REMOTE_USER environment variable for API calls too'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:authorize_login_delegation_auth_source_user_autocreate) do
    desc 'Name of the external auth source where unknown externally authentication users (see authorize_login_delegation) should be created (keep unset to prevent the autocreation)'
  end

  newproperty(:bmc_credentials_accessible, :boolean => true) do
    desc 'Permits access to BMC interface passwords through ENC YAML output and in templates'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:idle_timeout) do
    desc 'Log out idle users after a certain number of minutes'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:login_delegation_logout_url) do
    desc 'Redirect your users to this url on logout (authorize_login_delegation should also be enabled)'
  end

  newproperty(:oauth_active, :boolean => true) do
    desc '[READ ONLY] Foreman will use OAuth for API authorization'
    validate do |val|
      fail 'oauth_active is read-only'
    end
  end

  newproperty(:oauth_consumer_key) do
    desc '[READ ONLY] OAuth consumer key'
    validate do |val|
      fail 'oauth_consumer_key is read-only'
    end
  end

  newproperty(:oauth_consumer_secret) do
    desc '[READ ONLY] OAuth consumer secret'
    validate do |val|
      fail 'oauth_consumer_secret is read-only'
    end
  end

  newproperty(:oauth_map_users, :boolean => true) do
    desc '[READ ONLY] Foreman will map users by username in request-header. If this is set to false, OAuth requests will have admin rights.'
    validate do |val|
      fail 'oauth_map_users is read-only'
    end
  end

  newproperty(:require_ssl_smart_proxies, :boolean => true) do
    desc 'Client SSL certificates are used to identify Smart Proxies (:require_ssl should also be enabled)'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:restrict_registered_smart_proxies, :boolean => true) do
    desc 'Only known Smart Proxies may access features that use Smart Proxy authentication'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:ssl_ca_file) do
    desc '[READ ONLY] SSL CA file that Foreman will use to communicate with its proxies'
    validate do |val|
      fail 'ssl_ca_file is read-only'
    end
  end

  newproperty(:ssl_certificate) do
    desc '[READ ONLY] SSL Certificate path that Foreman would use to communicate with its proxies'
    validate do |val|
      fail 'ssl_certificate is read-only'
    end
  end

  newproperty(:ssl_client_cert_env) do
    desc 'Environment variable containing a client\'s SSL certificate'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:ssl_client_dn_env) do
    desc 'Environment variable containing the subject DN from a client SSL certificate'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:ssl_client_verify_env) do
    desc 'Environment variable containing the verification status of a client SSL certificate'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:ssl_priv_key) do
    desc '[READ ONLY] SSL Private Key file that Foreman will use to communicate with its proxies'
    validate do |val|
      fail 'ssl_priv_key is read-only'
    end
  end

  newproperty(:trusted_puppetmaster_hosts, :array_matching => :all) do
    desc 'Hosts that will be trusted in addition to Smart Proxies for access to fact/report importers and ENC output'
  end

  newproperty(:websockets_encrypt, :boolean => true) do
    desc '[READ ONLY] VNC/SPICE websocket proxy console access encryption (websockets_ssl_key/cert setting required)'
    validate do |val|
      fail 'websockets_encrypt is read-only'
    end
  end

  newproperty(:websockets_ssl_cert) do
    desc '[READ ONLY] Certificate that Foreman will use to encrypt websockets'
    validate do |val|
      fail 'websockets_ssl_cert is read-only'
    end
  end

  newproperty(:websockets_ssl_key) do
    desc '[READ ONLY] Private key file that Foreman will use to encrypt websockets'
    validate do |val|
      fail 'websockets_ssl_key is read-only'
    end
  end

end
