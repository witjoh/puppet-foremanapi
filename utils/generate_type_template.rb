require 'apipie-bindings'
require 'yaml'

@url = 'http://localhost/'
@username = 'admin'
@password = 'vPuf2FMJhPSkijVL'
@read_only_attr = {}

begin
  @read_only_attr = YAML.load_file('./read_only.yaml')
rescue  
  warn "Read only attributes yaml file (./read_only.yaml) could not be found.)"
end


@api = ApipieBindings::API.new({:uri => @url, :user => @username, :password => @password, :api_version => '2'})

# retrieve all setting data

def retrieve_all(type)
  begin
    object_data = []
    _page = 1
    begin
      _result = @api.resource(type.to_sym).call(:index, params = { :page => _page.to_s })
      object_data.concat(_result['results'])
      _page += 1
    end while _result['results'] != []
  rescue => e
    raise(Exception, "\n Could not retreive dat from  #{@url} for type #{type}: #{e.inspect}")
  end
  object_data
end


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

def group_by_category(the_hash)
  # filters all entries belonging to the 'category'
  result = []
  result = the_hash.group_by{ |h| h['category'] }
end

def generate_type_template(entry, file=nil)
  file = STDOUT unless file

  # Generates a property entry to be addded to a puppet
  # custom type definition.
  #
  case entry['settings_type']
  when "boolean"
    prop_attr=", :boolean => true"
  when "array"
    prop_attr=", :array_matching => :all"
  end
 
  # check if this is a readonly property
  category = entry["category"].split('::').last.downcase
  if @read_only_attr.key? category
    if @read_only_attr[category].include? entry["name"]
      readonly ="[READ ONLY] "
    end
  end

  file.puts "  newproperty(:#{entry['name']}#{prop_attr}) do"
  file.puts "    desc '#{readonly}#{entry['description'].gsub("'","\\\\'")}'"
  if readonly
    file.puts "    validate do |val|"
    file.puts "      fail '#{entry['name']} is read-only'"
    file.puts "    end"
  else
    case entry['settings_type']
    when "integer"
      file.puts "    munge do |value|"
      file.puts "      Integer(value)"
      file.puts "    end"
    when "string"
      # add extra validation rules
      case entry['default']
      when /^http/ # check for valid URL
        file.puts "    newvalues(URI::regexp(%w(http https)))"
      when /@/     # check for valid email
        file.puts "    newvalues(URI::MailTo::MAILTO_REGEXP)"
      when /^\//   # check for absolute path
        file.puts "    newvalues(/^(\\\/[^\\\/ ]*)+\\\/?$/)"
      end
      file.puts "   # munge do |value|"
      file.puts "   #   value.downcase"
      file.puts "   # end"
    when "boolean"
      file.puts "    newvalue(:true)"
      file.puts "    newvalue(:false)"
      file.puts "    munge do |value|"
      file.puts "      @resource.munge_boolean(value)"
      file.puts "    end"
    end
  end
  file.puts "  end"
  file.puts
end

def print_header(type, file=nil)
  file = STDOUT unless file

  file.puts "require 'uri'"
  file.puts "require 'puppet/parameter/boolean'"
  file.puts "require_relative './foremanapi_common'"
  file.puts
  file.puts "Puppet::Type.newtype(:foremanapi_settings_#{type}) do"
  file.puts "  @doc = 'Manage a foreman server #{type} settings.'"
  file.puts
  file.puts "  include ForemanApi_Common"
  file.puts
  file.puts "  newparam(:tfm_server, namevar: true) do"
  file.puts "    desc 'The hostname of the foreman server to manage.'"
  file.puts "    munge do |value|"
  file.puts "      value.downcase"
  file.puts "    end"
  file.puts "  end"
  file.puts
end

def print_footer(file=nil)
  file = STDOUT unless file

  file.puts "end"
end

object_data = retrieve_all('settings')

group_by_category(object_data).each do | key, value|
  subtype = key.split('::')[1].downcase
  open("foremanapi_settings_#{subtype}.rb", 'w') do |f|
    print_header(subtype, f)
    value.each do |entry|
      generate_type_template(entry, f)
    end
    print_footer(f)
  end
end
