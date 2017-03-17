node default {

  foremanapi_config {'testzone':
    parent     => 'localhost.localdomain',
    global     => true,
    #endpoints  => ['localhost.localdomain'],
  }
}
