require_relative '../foremanapi_settings'

Puppet::Type.type(:foremanapi_settings_auth).provide :ruby, :parent => Puppet::Provider::ForemanApi_Settings do

  confine :feature => :apipie_bindings

  mk_resource_methods

  @subtype = 'auth'

  def flush
    Puppet::Provider::ForemanApi_Settings.flush(@resource)
  end

end
