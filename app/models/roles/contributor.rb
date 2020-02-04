module Roles
  class Contributor
    include Base

    register :contributor, self

    def level
      2
    end
  end
end
