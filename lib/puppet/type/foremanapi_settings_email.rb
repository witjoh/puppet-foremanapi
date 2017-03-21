require 'uri'
require 'puppet/parameter/boolean'
require_relative './foremanapi_common'

Puppet::Type.newtype(:foremanapi_settings_email) do
  @doc = 'Manage a foreman server email settings.'

  include ForemanApi_Common

  newparam(:tfm_server, namevar: true) do
    desc 'The hostname of the foreman server to manage.'
    munge do |value|
      value.downcase
    end
  end

  newproperty(:delivery_method) do
    desc '[READ ONLY] Method used to deliver email'
    validate do |val|
      fail 'delivery_method is read-only'
    end
  end

  newproperty(:email_reply_address) do
    desc 'Email reply address for emails that Foreman is sending'
    newvalues(URI::MailTo::MAILTO_REGEXP)
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:email_subject_prefix) do
    desc 'Prefix to add to all outgoing email'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:sendmail_arguments) do
    desc '[READ ONLY] Specify additional options to sendmail'
    validate do |val|
      fail 'sendmail_arguments is read-only'
    end
  end

  newproperty(:sendmail_location) do
    desc '[READ ONLY] The location of the sendmail executable'
    validate do |val|
      fail 'sendmail_location is read-only'
    end
  end

  newproperty(:send_welcome_email, :boolean => true) do
    desc 'Send a welcome email including username and URL to new users'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:smtp_address) do
    desc 'Address to connect to'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:smtp_authentication) do
    desc '[READ ONLY] Specify authentication type, if required'
    validate do |val|
      fail 'smtp_authentication is read-only'
    end
  end

  newproperty(:smtp_domain) do
    desc '[READ ONLY] HELO/EHLO domain'
    validate do |val|
      fail 'smtp_domain is read-only'
    end
  end

  newproperty(:smtp_enable_starttls_auto, :boolean => true) do
    desc '[READ ONLY] SMTP automatic STARTTLS'
    validate do |val|
      fail 'smtp_enable_starttls_auto is read-only'
    end
  end

  newproperty(:smtp_openssl_verify_mode) do
    desc '[READ ONLY] When using TLS, you can set how OpenSSL checks the certificate'
    validate do |val|
      fail 'smtp_openssl_verify_mode is read-only'
    end
  end

  newproperty(:smtp_password) do
    desc '[READ ONLY] Password to use to authenticate, if required'
    validate do |val|
      fail 'smtp_password is read-only'
    end
  end

  newproperty(:smtp_port) do
    desc '[READ ONLY] Port to connect to'
    validate do |val|
      fail 'smtp_port is read-only'
    end
  end

  newproperty(:smtp_user_name) do
    desc '[READ ONLY] Username to use to authenticate, if required'
    validate do |val|
      fail 'smtp_user_name is read-only'
    end
  end

end
