#default base dn
default.cg_openldap.basedn = "dc=capgemini,dc=com"

#default description of the base dn 
default.cg_openldap.basedn_description = "DN description"

#default openldap server
default.cg_openldap.server = "localhost"

#default rootDN
default.cg_openldap.rootdn = "cn=Manager,#{node.cg_openldap.basedn}"

#default rootPassword, will be stored in SSHA
#should be overriden by a role attribute
default.cg_openldap.rootpassword = "pa$$word"

#default cookbook which defines the schemas to import
#the cookbook shall store these schemas under files/default/schemas/
#each schema file shall have a .schema extension
default.cg_openldap.schema_cookbook = nil

#default additional schemas to import
default.cg_openldap.additional_schemas = []

#default classes for users
default.cg_openldap.user_classes = %W[top inetOrgPerson posixAccount]
