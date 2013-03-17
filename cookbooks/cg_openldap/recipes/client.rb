CGOpenldap.check_supported_platform node

package "openldap-clients" do
  action :upgrade
end

ldap_conf = case node[:platform]
when "redhat"
  "/etc/openldap/ldap.conf"
end

template ldap_conf do
  user "root"
  group "root"
  source "ldap.conf.erb"
end
