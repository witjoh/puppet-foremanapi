require 'uri'
require 'puppet/parameter/boolean'
require_relative './foremanapi_common'

Puppet::Type.newtype(:foremanapi_settings_puppet) do
  @doc = 'Manage a foreman server puppet settings.'

  include ForemanApi_Common

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:always_show_configuration_status, :boolean => true) do
    desc 'All hosts will show a configuration status even when a Puppet smart proxy is not assigned'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:create_new_host_when_facts_are_uploaded, :boolean => true) do
    desc 'Foreman will create the host when new facts are received'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:create_new_host_when_report_is_uploaded, :boolean => true) do
    desc 'Foreman will create the host when a report is received'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:default_puppet_environment) do
    desc 'Foreman will default to this puppet environment if it cannot auto detect one'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:Default_variables_Lookup_Path) do
    desc 'Foreman will evaluate host smart variables in this order by default'
  end

  newproperty(:Enable_Smart_Variables_in_ENC, :boolean => true) do
    desc 'Foreman smart variables will be exposed via the ENC yaml output'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:enc_environment, :boolean => true) do
    desc 'Foreman will explicitly set the puppet environment in the ENC yaml output. This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:host_group_matchers_inheritance, :boolean => true) do
    desc 'Foreman host group matchers will be inherited by children when evaluating smart class parameters'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:interpolate_erb_in_parameters, :boolean => true) do
    desc 'Foreman will parse ERB in parameters value in the ENC output'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:legacy_puppet_hostname, :boolean => true) do
    desc 'Foreman will truncate hostname to `puppet` if it starts with puppet'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:modulepath) do
    desc 'Foreman will set this as the default Puppet module path if it cannot auto detect one'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:outofsync_interval) do
    desc 'Duration in minutes after the Puppet interval for servers to be classed as out of sync.'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:Parametrized_Classes_in_ENC, :boolean => true) do
    desc 'Foreman will use the new (2.6.5+) format for classes in the ENC yaml output'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:puppet_interval) do
    desc 'Puppet interval in minutes'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:puppetrun, :boolean => true) do
    desc 'Enable puppetrun support'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:puppet_server) do
    desc 'Default Puppet server hostname'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:update_environment_from_facts, :boolean => true) do
    desc 'Foreman will update a host\'s environment from its facts'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:update_subnets_from_facts, :boolean => true) do
    desc 'Foreman will update a host\'s subnet from its facts'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:use_uuid_for_certificates, :boolean => true) do
    desc 'Foreman will use random UUIDs for certificate signing instead of hostnames'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

end
