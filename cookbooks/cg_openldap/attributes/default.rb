# Default base dn
default.cg_openldap.basedn = "dc=example,dc=com"

# Default openldap server
default.cg_openldap.ldap_server = "localhost"

# Default openldap port
default.cg_openldap.ldap_port = "389"

# Default rootDN
default.cg_openldap.rootdn = "cn=Manager,#{node.cg_openldap.basedn}"

# Default rootPassword, will be stored in SSHA
# It should be overriden by a role attribute
default.cg_openldap.rootpassword = "pa$$word"

# Default log level of the accesses to the bdb database
default.cg_openldap.ldap_log_level = "-1"

default.cg_openldap.acls = ["to attrs=userPassword by self =xw by anonymous auth by * none", "to * by self write by users read by * none"]

# Default cookbook which defines the schemas to import
# The cookbook shall store these schemas under files/default/schemas/
# Each schema file shall have a .schema extension
default.cg_openldap.schema_cookbook = nil

# Default additional schemas to import
default.cg_openldap.additional_schemas = []

# Default classes for users
default.cg_openldap.user_classes = %W[top inetOrgPerson posixAccount]

# Default DIT to create in the directory.
# This attribute can be overriden by the 'cg_openldap/dit' data bag item.
# If this data bag item exists, the DIT is searched under the "dit" hash key.
# Each entry of the DIT is defined by an hash, where:
# - the key is the part of the DN relative to its parent
# - the value is a hash including the following keys:
#   - "attrs": hash defining all attributes of the entry
#   - "children": hash of the children entries
default.cg_openldap.dit = {
  "#{node.cg_openldap.basedn}" => {
    attrs: {
      objectClass: ["organization", "dcObject"], 
      description: "DN description", 
      o: "organization"
    },
    children: {
      "ou=users" => {
        attrs: {
          objectClass: %W[top organizationalUnit]
        }
      },
      "ou=groups" => {
        attrs: {
          objectClass: %W[top organizationalUnit]
        }
      }
    }
  }
}
