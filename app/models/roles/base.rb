module Roles
  module Base
    include Comparable
    extend ActiveSupport::Concern

    def level
      raise NotImplementedError
    end

    def <=>(other)
      level <=> other.level
    end

    class_methods do
      def register(name, klass)
        Roles::MAP[name] = klass
      end
    end
  end
end
