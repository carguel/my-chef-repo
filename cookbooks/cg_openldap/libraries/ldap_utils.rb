require 'active_ldap'

class Chef::Recipe::LDAPUtils

  # Test if the local directory contains entries under the provided base and matching a filter if given.
  # The connection to the LDAP is made with the EXTERNAL SASL scheme.
  # @param [Hash] opts options
  # @option opts [String] :base the basedn to search from (mandatory)
  # @option opts [String] :filter the filter to match
  # @return [TrueClass|FalseClass] true if entries are found, false otherwise
  def self.contains?(opts = {})
      opts[:base] or raise ":base option shall be provided"
      filter = ""
      filter = "'#{opts[:filter]}'"  if opts[:filter]
      system("ldapsearch -Y EXTERNAL -H ldapi:/// -b #{opts[:base]} #{filter} | grep -q 'numEntries: '")
  end

  def self.ssha_password(clear_password)
    ActiveLdap::UserPassword.ssha clear_password
  end
end
