# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# https://docs.puppet.com/guides/tests_smoke.html
#

foremanapi_settings_general { 'foreman.vagrant.vdab.be':
  administrator         => 'root@vagrant.vdab.be',
  db_pending_migration  => true,
  db_pending_seed       => false,
  entries_per_page      => '20',
  fix_db_cache          => false,
  foreman_url           => 'https://foreman.vagrant.vdab.be',
  host_power_status     => true,
  max_trend             => '30',
  proxy_request_timeout => '60',
  use_gravatar          => false,
  login_text            => undef,
}

