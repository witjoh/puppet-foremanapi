require 'uri'
require 'puppet/parameter/boolean'
require_relative './foremanapi_common'

Puppet::Type.newtype(:foremanapi_settings_provisioning) do
  @doc = 'Manage a foreman server provisioning settings.'

  include ForemanApi_Common

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:access_unattended_without_build, :boolean => true) do
    desc 'Allow access to unattended URLs without build mode being used'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:clean_up_failed_deployment, :boolean => true) do
    desc 'Foreman will delete virtual machine if provisioning script ends with non zero exit code'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:dns_conflict_timeout) do
    desc 'Timeout for DNS conflict validation (in seconds)'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:ignored_interface_identifiers) do
    desc 'Ignore interfaces that match these values during facts importing, you can use * wildcard to match names with indexes e.g. macvtap*'
  end

  newproperty(:ignore_puppet_facts_for_provisioning, :boolean => true) do
    desc 'Stop updating IP address and MAC values from Puppet facts (affects all interfaces)'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:libvirt_default_console_address) do
    desc 'The IP address that should be used for the console listen address when provisioning new virtual machines via Libvirt'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:manage_puppetca, :boolean => true) do
    desc 'Foreman will automate certificate signing upon provision of new host'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:name_generator_type) do
    desc 'Random gives unique names, MAC-based are longer but stable (and only works with bare-metal)'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:query_local_nameservers, :boolean => true) do
    desc 'Foreman will query the locally configured resolver instead of the SOA/NS authorities'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:remote_addr) do
    desc 'If Foreman is running behind Passenger or a remote load balancer, the IP should be set here. This is a regular expression, so it can support several load balancers, i.e: (10.0.0.1|127.0.0.1)'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:root_pass) do
    desc 'Default encrypted root password on provisioned hosts'
  end

  newproperty(:safemode_render, :boolean => true) do
    desc 'Enable safe mode config templates rendering (recommended)'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:token_duration) do
    desc 'Time in minutes installation tokens should be valid for, 0 to disable token generation'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:unattended_url) do
    desc 'URL hosts will retrieve templates from during build (normally http as many installers don\'t support https)'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:update_ip_from_built_request, :boolean => true) do
    desc 'Foreman will update the host IP with the IP that made the built request'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:use_shortname_for_vms, :boolean => true) do
    desc 'Foreman will use the short hostname instead of the FQDN for creating new virtual machines'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

end
