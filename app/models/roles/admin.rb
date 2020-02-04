module Roles
  class Admin
    include Base

    register :admin, self

    def level
      3
    end
  end
end
