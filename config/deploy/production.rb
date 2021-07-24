# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "164.90.163.230", user: "deployer", roles: %w{app db web}, primary: true
server "167.99.37.58", user: "deployer", roles: %w{app db web}, primary: true
set :rail_env, :production

# Global options
# --------------
set :ssh_options, {
 keys: %w(/Users/secretpray/.ssh/id_rsa),
 forward_agent: true,
 auth_methods: %w(publickey password),
 port: 2221
}
