require 'uri'
require 'puppet/parameter/boolean'
require_relative './foremanapi_common'

Puppet::Type.newtype(:foremanapi_settings_general) do
  @doc = 'Manage a foreman server general settings.'

  # bring the finction into the local scope of the class
  #
  include ForemanApi_Common

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:administrator) do
    desc 'The default administrator email address'
    _domain = Facter.value('domain')
    newvalues(URI::MailTo::MAILTO_REGEXP)
    munge do |value|
      value.downcase
    end
  end

  newproperty(:db_pending_migration, :boolean => true) do
    desc 'Should the `foreman-rake db:migrate` be executed on the next run of the installer modules?'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:db_pending_seed, :boolean => true) do
    desc 'Should the `foreman-rake db:seed` be executed on the next run of the installer modules?'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:entries_per_page) do
    desc 'Number of records shown per page in Foreman'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:fix_db_cache, :boolean => true) do
    desc 'Fix DB cache on next Foreman restart'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:foreman_url) do
    desc 'URL where your Foreman instance is reachable (see also Provisioning > unattended_url)'
    validate do | value|
      unless URI.parse(value).is_a?(URI::HTTP)
        fail("Invalid foreman_url #{value}")
      end
    end
  end

  newproperty(:host_power_status, :boolean => true) do
    desc 'Show power status on host index page. This feature calls to compute resource providers which may lead to decreased performance on host listing page.'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:login_text) do
    desc 'Text to be shown in the login-page footer. Set to empty string to clear this setting'
  end

  newproperty(:max_trend) do
    desc 'Max days for Trends graphs'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:proxy_request_timeout) do
    desc 'Max timeout for REST client requests to smart-proxy'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:use_gravatar, :boolean => true) do
    desc 'Foreman will use gravatar to display user icons'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end
end
