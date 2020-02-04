module Roles
  MAP = {}

  def self.[](role)
    MAP[role.to_sym].new
  end
end

require_relative 'roles/admin'
require_relative 'roles/guest'
require_relative 'roles/consumer'
require_relative 'roles/contributor'
