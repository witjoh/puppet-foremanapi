require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'foremanapi', 'rest.rb'))

require 'pry_debug'

def filter(object_data)
  # filters out the settings category from the object_data
  # and returns the result
  res = []
  res.push(object_data.group_by{|t| t['category']}['Setting::General'])
  return res
end

def map(object_data)
  # maps the data array to a resource map
  # and returns a hash of attributes
  # We expect the filtered hash
  resource = {}
  resource[:tfm_server] = ForemanApi::Rest.get_server_id
  resource[:name] = resource[:tfm_server]
  resource[:provider] = :ruby
  object_data.each do |h|
    resource[ h["name"].to_sym ] = h["value"]
  end
  return resource
end

Puppet::Type.type(:foremanapi_settings_general).provide(:ruby) do

  confine :feature => :apipie_bindings

  mk_resource_methods

  def self.instances
    ForemanApi::Rest.read_config(Facter.value('fqdn'))
    ForemanApi::Rest.init_connection
    raw_att = filter(ForemanApi::Rest.index('settings'))
    raw_att.collect do |h|
      self.new(map(h))
    end
  end

  def self.prefetch(resources)
    res = instances
    res.keys.each do |name|
      if provider = res.find{ |resource| resource.name == name }
        resources[name].provider = provider
      end
    end
  end

  def update
  end

  def flush
  end

  def exists?
     @property_hash[:tfm_server] == ForemanApi::Rest.get_server_id
  end
#
#  def tfm_server
#    @property_hash[:tfm_server]
#  end
#
#  def administrator
#    @property_hash[:administrator]
#  end
#
#  def db_pending_migration
#    @property_hash[:db_pending_migration]
#  end
#
#  def db_pending_seed
#    @property_hash[:db_pending_seed]
#  end
#
#  def entries_per_page
#    @property_hash[:entries_per_page]
#  end
#
#  def fix_db_cache
#    @property_hash[:fix_db_cache]
#  end
#
#  def foreman_url
#    @property_hash[:foreman_url]
#  end
#
#  def host_power_status
#    @property_hash[:host_power_status]
#  end
#
#  def login_text
#    @property_hash[:login_text]
#  end
#
#  def max_trend
#    @property_hash[:max_trend]
#  end
#
#  def proxy_request_timeout
#    @property_hash[:proxy_request_timeout]
#  end
#
#  def use_gravatar
#    @property_hash[:use_gravatar]
#  end
#
end
