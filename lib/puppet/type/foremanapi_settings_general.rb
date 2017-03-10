require 'pry_debug'

Puppet::Type.newtype(:foremanapi_settings_general) do
  @doc = 'Manage a foreman server general settings.'

  require 'uri'
  require 'puppet/parameter/boolean'

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:administrator) do
    desc 'The default administrator email address'
    _domain = Facter.value('domain')
    defaultto { "root@#{_domain}" }
    newvalues(URI::MailTo::MAILTO_REGEXP)
    munge do |value|
      value.downcase
    end
    def retrieve
      provider.administrator
    end
  end

  newproperty(:db_pending_migration, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Should the `foreman-rake db:migrate` be executed on the next run of the installer modules?'
    defaultto true

    def retrieve
      provider.db_pending_migration
    end
  end

  newproperty(:db_pending_seed, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Should the `foreman-rake db:seed` be executed on the next run of the installer modules?'
    defaultto true
    def retrieve
      provider.db_pending_seed
    end
  end

  newproperty(:entries_per_page) do
    desc 'Number of records shown per page in Foreman'
    defaultto 20
    munge do |value|
      Integer(value)
    end
    def retrieve
      provider.entries_per_page
    end
  end

  newproperty(:fix_db_cache, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Fix DB cache on next Foreman restart'
    defaultto false
    def retrieve
      provider.fix_db_cache
    end
  end

  newproperty(:foreman_url) do
    desc 'URL where your Foreman instance is reachable (see also Provisioning > unattended_url)'
    _fqdn = Facter.value('fqdn')
    defaultto { "https://#{_fqdn}" }
    validate do | value|
      unless URI.parse(value).is_a?(URI::HTTP)
        fail("Invalid foreman_url #{value}")
      end
    end
    def retrieve
      provider.foreman_url
    end
  end

  newproperty(:host_power_status, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Show power status on host index page. This feature calls to compute resource providers which may lead to decreased performance on host listing page.'
    defaultto true
    def retrieve
      provider.host_power_status
    end
  end

  newproperty(:login_text) do
    desc 'Text to be shown in the login-page footer'
    def retrieve
      provider.login_text
    end
  end

  newproperty(:max_trend) do
    desc 'Max days for Trends graphs'
    defaultto 30
    munge do |value|
      Integer(value)
    end
    def retrieve
      provider.max_trend
    end
  end

  newproperty(:proxy_request_timeout) do
    desc 'Max timeout for REST client requests to smart-proxy'
    defaultto 60
    munge do |value|
      Integer(value)
    end
    def retrieve
      provider.proxy_request_timeout
    end
  end

  newproperty(:use_gravatar, :boolean => true, :parent => Puppet::Property::Boolean) do
    desc 'Foreman will use gravatar to display user icons'
    defaultto false
    def retrieve
      provider.use_gravatar
    end
  end
end
