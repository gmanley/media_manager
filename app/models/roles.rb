module Roles
  MAP = {}

  def self.all
    MAP
  end

  def self.[](role)
    MAP[role.to_sym].new
  end
end

require_relative 'roles/admin'
require_relative 'roles/guest'
require_relative 'roles/consumer'
require_relative 'roles/contributor'
