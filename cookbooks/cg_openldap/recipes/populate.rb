require 'active_ldap'

ruby_block 'setup_ldap_connection' do
  block do
    basedn = node.cg_openldap.basedn
    ActiveLdap::Base.setup_connection :host => 'localhost', 
                                      :port => 389, 
                                      :base => basedn, 
                                      :bind_dn => "cn=Manager,#{basedn}", 
                                      :password => 'pa$$word'
  end
end

ruby_block 'define_ldap_models' do
  block do
    user_classes = node.cg_openldap.user_classes
    ::User = Class.new(ActiveLdap::Base) do
      ldap_mapping classes: user_classes, prefix: "ou=users"
      belongs_to :groups, class_name: '::Groups', :many => 'memberUid'  
    end

    ::Group = Class.new(ActiveLdap::Base) do
      ldap_mapping :classes => ['top', 'posixGroup'], :prefix => 'ou=Groups'
      has_many :members, :class_name => '::User', :wrap => 'memberUid'
      has_many :primary_members, :class_name => '::User', :foreign_key => 'gidNumber', :primary_key => 'gidNumber'
    end
  end
  action :create
end



data_bag('ldap_users').each do |user_id|
  user = data_bag_item('ldap_users', user_id)
  Chef::Log.info "add/modify user #{user["uid"]}"
  ruby_block 'add_user' do
    block do
      #u = User.find(user["cn"]) || ::User.new(user[:cn])
      u = ::User.new(user[:cn])
      user.each do |key, value|
        u.send("#{key}=", value)
      end
      u.save
    end
  end
end
