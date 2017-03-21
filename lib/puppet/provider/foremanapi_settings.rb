require_relative '../../puppet_x/foremanapi/rest'

class Puppet::Provider::ForemanApi_Settings < Puppet::Provider 

  ENDPOINT = 'settings'
  CATEGORY = 'setting'
  @subtype = ''

  def self.instances
    instances = []

    ForemanApi::Rest.read_config(Facter.value('fqdn'))
    ForemanApi::Rest.init_connection
    raw_att = filter(ForemanApi::Rest.index(ENDPOINT))
    raw_att.collect do |h|
      instances << new(map(h))
    end
    instances
  end

  def self.prefetch(resources)
    instances.each do | prov |
      if res = resources[prov.name]
       res.provider = prov
      end
    end
  end

  def self.flush(res)
    ForemanApi::Rest.update(ENDPOINT, unmap(res.original_parameters))
  end

  def self.exists?
     @property_hash[:tfm_server] == ForemanApi::Rest.server_id
  end

  def self.filter(object_data)
    # filters out the settings category from the object_data
    # and returns the result
    res = []
    res.push(object_data.group_by{|t| t['category']}["#{CATEGORY.capitalize}::#{@subtype.capitalize}"])
    return res
  end

  def self.map(object_data)
    # maps the data array to a resource map
    # and returns a hash of attributes
    # We expect the filtered hash
    resource = {}
    resource[:tfm_server] = ForemanApi::Rest.server_id
    resource[:name] = resource[:tfm_server]
    resource[:provider] = :ruby
    object_data.each do |h|
      if h['settings_type'] == "boolean" then
        if h["value"] then
          the_value = :true
        else
          the_value = :false
        end
      else
        the_value = h["value"]
      end
      resource[ h["name"].to_sym ] = the_value
    end
    return resource
  end

  def self.unmap(parameters)
    # maps a parameter list back to the object_data
    # suitable ta pass to the rest call
    # returns a hash
    object_data = []
    parameters.each do | key, value |
      object_data  << { :name => key.to_s, :value => value }
      case value
      when true, :true
        value = true
      when false, :false
        value = false
      end
    end
    object_data
  end
end
