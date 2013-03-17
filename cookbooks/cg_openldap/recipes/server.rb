# setup openldap server


CGOpenldap.check_supported_platform node

include_recipe "cg_openldap::client"

# Install needed packages
package "openldap-servers" do
  action :upgrade
end

# Enable slapd service and stop it in order to complete its configuration
service "slapd" do
  action [:enable, :stop]
end

# Configure the base DN, the root DN and its password
ruby_block "set_basedn" do
  block do

    slapd_conf_file = '/etc/openldap/slapd.d/cn=config/olcDatabase={2}bdb.ldif'
    password = LDAPUtils.ssha_password(node.cg_openldap.rootpassword)

    f = Chef::Util::FileEdit.new(slapd_conf_file)
    f.insert_line_if_no_match(/olcAccess:/, "olcAccess: {0}to *  by dn.base=\"gidNumber=0+uidNumber=0,cn=peercred,cn=externa\n l,cn=auth\" manage  by * none") #needed for the DIT creation
    f.search_file_replace_line(/olcSuffix:/, "olcSuffix: #{node.cg_openldap.basedn}")
    f.search_file_replace_line(/olcRootDN:/, "olcRootDN: #{node.cg_openldap.rootdn}")
    f.search_file_delete_line(/olcRootPW:/)
    f.insert_line_after_match(/olcRootDN:/, "olcRootPW: #{password}")
    f.write_file
  end
  action :create
  notifies :start, "service[slapd]", :immediately
end

# Create the DIT
template "/tmp/dit.ldif" do
  mode 00644
  source "dit.ldif.erb"
end

execute "init DIT" do
  command "ldapadd -Y EXTERNAL -H ldapi:/// -D #{node.cg_openldap.rootdn} < /tmp/dit.ldif"
  not_if {LDAPUtils.contains? base: node.cg_openldap.basedn}
end

file "/tmp/dit.ldif" do
  action :delete
end
