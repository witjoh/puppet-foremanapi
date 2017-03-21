# foremanapi

Puppet custom Type for the foreman using the ruby API

Also my first steps in ruby development ....

And still a lot of work to do

how to run it in a vagrant box .

In the root of the cloned git repo :

    [vagrant@foreman puppet-foremanapi]$ export RUBYLIB=/vagrant/playground/puppet-foremanapi/lib/
    [vagrant@foreman puppet-foremanapi]$ bundler install
    [vagrant@foreman puppet-foremanapi]$ bundler exec puppet resource foremanapi_settings_general
    foremanapi_settings_general { 'foreman.vagrant.be':
    administrator         => 'root@vagrant.be',
    db_pending_migration  => 'true',
    db_pending_seed       => 'true',
    entries_per_page      => '20',
    foreman_url           => 'https://foreman.vagrant.be',
    host_power_status     => 'true',
    max_trend             => '30',
    proxy_request_timeout => '60',
    }

Running inside an IRB session

    [vagrant@foreman puppet-foremanapi]$ export RUBYLIB=/vagrant/playground/puppet-foremanapi/lib/
    [vagrant@foreman puppet-foremanapi]$ irb
    require 'puppet'
    require 'uri'
    require 'apipei-bindings'
    load '/vagrant/playground/puppet-foremanapi/lib/puppet_x/foremanapi/rest.rb'
    Puppet::Type.type(:foremanapi_settings_general)

Need to add more proper debugging examples .....

In the utils directory, there is a little script that generates a type definition template by querying the foreman server for the attributes available.

This will generate the templates for all sub categories for the settings. Some settings are readonly.  I did not find a way to retrieve the fact that a setting is readonly using the apipie metadata, so I decided to list those attribute in a yaml file.

