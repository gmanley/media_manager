module Roles
  class Guest
    include Base

    register :guest, self

    def level
      0
    end
  end
end
