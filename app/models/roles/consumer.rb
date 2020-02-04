module Roles
  class Consumer
    include Base

    register :consumer, self

    def level
      1
    end
  end
end
