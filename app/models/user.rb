class User < ApplicationRecord
  include Clearance::User

  def role_class
    Roles[role]
  end
end
