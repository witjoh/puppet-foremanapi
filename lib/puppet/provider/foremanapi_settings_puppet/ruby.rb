require_relative '../foremanapi_settings'

Puppet::Type.type(:foremanapi_settings_puppet).provide :ruby, :parent => Puppet::Provider::ForemanApi_Settings do

  confine :feature => :apipie_bindings

  mk_resource_methods

  @subtype = 'puppet'

  def flush
    Puppet::Provider::ForemanApi_Settings.flush(@resource)
  end

end
