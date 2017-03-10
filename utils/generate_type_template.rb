require 'apipie-bindings'


# Conenctions settings to localhost

url = 'http://localhost/'
username = 'admin'
password = 'vPuf2FMJhPSkijVL'


api = ApipieBindings::API.new({:uri => url, :user => username, :password => password, :api_version => '2'})

# disable pagination by selection to many entiries/page

settings = api.resource(:settings).call(:index, params = { :per_page => '500'})


# since we cannot filter on category for settings, we will do it in ruby
# params : the results has of the api call
# returns : array of availbakle categories
#
def get_available_categories(the_hash)
  result = []
  the_hash.each do |h|
    result.push(h['category']) unless result.include?(h['category'])
  end
  return result
end

def filter_settings_by_category(the_hash, category)
  # filters all entries belonging to the 'category'
  result = []
  result = the_hash.group_by { |h| h['category'] }
  return result[category]
end

def generate_type_template(entry)
  # Generates a property entry to be addded to a puppet
  # custom type definition.
  #
  if entry['settings_type'] == "boolean"
    prop_attr=", :boolean => true, :parent => Puppet::Parameter::Boolean"
  end

  p "newproperty(:#{entry['name']}#{prop_attr}) do"
  p "  desc '#{entry['description']}'"
  p "  defaultto #{entry['default']}"
  case entry['settings_type']
  when "integer"
    p "  munge do |value|"
    p "    Integer(value)"
    p "  end"
  when "string"
    p "  munge do |value|"
    p "    value.downcase"
    p "  end"
  end
  p "end"
  p
end

get_available_categories(settings['results']).each do |cat| 
  filter_settings_by_category(settings['results'],cat).each do | entry |
    generate_type_template(entry)
  end
end
