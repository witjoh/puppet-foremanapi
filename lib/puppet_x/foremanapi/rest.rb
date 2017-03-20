require 'apipie-bindings'
require 'yaml'
#require 'puppetx'

module ForemanApi
  # wrapper class to handle all rest calls to Foreman api
  class Rest
    API_VERSION = '2'

    @@config_file
    @@config = {}
    @@api_handler = nil
    # initialize the connection when loading the class

    def self.server_id
      @@config[:server_id]
    end

    def self.sub_type(type, action)
      # lookup the parameter for the action where values are
      # assigned to in the api call
      #
      # We assume this will always be the last one
      result = @@api_handler.resource(type.to_sym).action(action.to_sym).params.last.to_s.scan(/\*\w*/).join.tr('*','')
      if result == "" then
        return nil
      else
        return result
      end
    end
      
    def self.read_config(server_id='localhost')

      # read the configuration file to obtain the needed info 
      # for server_id to be used to setup the REST call
      # The location of this file is ~/.tfm.yaml
      # config file pattern with following structure.
      # ---
      # foreman.example.com:
      #   user: 'admin'
      #   password: 'vPuf2FMJhPSkijVL'
      #   port: 443
      #   protocol: 'https'
      # localhost:
      #   user: 'admin'
      #   password: 'vPuf2FMJhPSkijVL'
      #   port: 80
      #   protocol: 'https'
      if @@config == {} or @@config[:server_id] != server_id then
        if Facter.value('id') == 'root' then
          @@config_file = '/root/.tfm.yaml'
        else
          @@config_file = "/home/#{Facter.value('id')}/.tfm.yaml"
        end

        Puppet.debug("Foremanpi::Rest.red_config : Loading confg data for #{server_id} from #{@@config_file}")

        begin
          the_conf = YAML.load_file(@@config_file)
        rescue Exception => e
          raise(Exception, "\nForeman REST API error: #{e.inspect}")
        end

        if the_conf.has_key?(server_id) then

          uri_protocol = 'http'
          uri_port = ''

          @@config = Hash[the_conf[server_id].map { |k, v| [k.to_sym, v] }]
          if @@config.has_key?(:protocol) then
            uri_protocol = @@config[:protocol]
          end
          if @@config.has_key?(:port) then
            uri_port = ":#{@@config[:port]}"
          end
          @@config[:uri] = "#{uri_protocol}://#{server_id}#{uri_port}/"
          @@config[:server_id] = server_id
        else
          raise(Exception, "No configuration for #{server_id} in #{@@config_file} available")
        end
        Puppet.debug("Foremanpi::Rest.red_config : Successfull loading config data for #{server_id}")
        return
      end
    end

    def self.init_connection
      Puppet.debug("Foremanpi::Rest.init_connection Setting up the API connection Handler")
      begin
        if not @@api_handler then
          @@api_handler = ApipieBindings::API.new({
            :uri  => @@config[:uri],
            :user => @@config[:user],
            :password => @@config[:password],
            :api_version => API_VERSION,
          })
        end
      rescue => e
        raise(Exception, "\nCould not setup API connection to #{@@config[:server_id]}: #{e.inspect}")
      end
    end

    def self.index(type)
      # returns an array of hashes with all enties from #{type}
      Puppet.debug("Foremanpi::Rest.index retrieving all records from type: #{type}")
      begin
        object_data = []
        _page = 1
        begin
          _result = @@api_handler.resource(type.to_sym).call(:index, params = { :page => _page.to_s })
          object_data.concat(_result['results'])
          _page += 1
        end while _result['results'] != []
      rescue => e
        raise(Exception, "\n Could not retreive dat from  #{@@config[:server_id]} for type #{type}: #{e.inspect}")
      end
      return object_data
    end
      
    def self.create(type, object_data)
      Puppet.debug("Foremanpi::Rest.create adding a new resource from type #{type}")
    
    end

    def self.update(type, object_data)
      sub_type = sub_type(type, 'update')
      Puppet.debug("Foremanpi::Rest.update a resource from type #{type}")
      object_data.each do |record|
        begin 
          @@api_handler.resource(type.to_sym).call(:update, :id => record[:name], sub_type.to_sym => {:value => record[:value]} )
        rescue => e
          raise(Exception, "\n Could not update #{type} #{record[:name]} : #{e.inspect}")
        end
      end
    end

    def self.destroy(type, object_data)
      Puppet.debug("Foremanpi::Rest.destroy a resource from type #{type}")
    end

  end
end
