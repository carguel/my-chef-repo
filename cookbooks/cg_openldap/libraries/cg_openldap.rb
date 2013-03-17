class Chef::Recipe::CGOpenldap
  def self.check_supported_platform(node)
    if node[:platform] != "redhat"
      raise "platform #{node[:platform]} not supported"
    end
  end
end
