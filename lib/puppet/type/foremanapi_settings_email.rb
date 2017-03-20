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
    desc 'Method used to deliver email'
   # munge do |value|
   #   value.downcase
   # end
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
    desc 'Specify additional options to sendmail'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:sendmail_location) do
    desc 'The location of the sendmail executable'
   # munge do |value|
   #   value.downcase
   # end
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
    desc 'Specify authentication type, if required'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:smtp_domain) do
    desc 'HELO/EHLO domain'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:smtp_enable_starttls_auto, :boolean => true) do
    desc 'SMTP automatic STARTTLS'
    newvalue(:true)
    newvalue(:false)
    munge do |value|
      @resource.munge_boolean(value)
    end
  end

  newproperty(:smtp_openssl_verify_mode) do
    desc 'When using TLS, you can set how OpenSSL checks the certificate'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:smtp_password) do
    desc 'Password to use to authenticate, if required'
   # munge do |value|
   #   value.downcase
   # end
  end

  newproperty(:smtp_port) do
    desc 'Port to connect to'
    munge do |value|
      Integer(value)
    end
  end

  newproperty(:smtp_user_name) do
    desc 'Username to use to authenticate, if required'
   # munge do |value|
   #   value.downcase
   # end
  end

end
