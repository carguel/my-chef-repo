chef_gem 'net-ldap'
chef_gem 'activeldap'

class Chef::Recipe
    include CGOpenldap
end

lu = LDAPUtils.new(node.cg_openldap.ldap_server, 
                   node.cg_openldap.ldap_port, 
                   node.cg_openldap.rootdn, 
                   node.cg_openldap.rootpassword)

parse_populate_data_bag_item do |dn, attrs|
  ruby_block "add_entry_#{dn}" do
    block do

      # hash the password if needed
      password = attrs['userPassword']
      if (password && ! password.match(/\{(?:S?SHA|MD5)\}/))
        attrs["userPassword"] = LDAPUtils.ssha_password password
      end

      Chef::Log.info "add entry dn=#{dn}, attrs=#{attrs}"
      lu.add_entry(dn, attrs)
    end
  end
end
