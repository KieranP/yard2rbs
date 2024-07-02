# frozen_string_literal: true

class Sample
  class User
    # @return [String]
    def greeting
      'Hello'
    end

    class Admin < self
      # @return [String]
      def greeting
        'Hello'
      end
    end

    class Superadmin < Admin
      # @return [String]
      def greeting
        'Hello'
      end
    end
  end

  class Manager < User
    # @return [String]
    def greeting
      'Hello'
    end
  end

  class ManagerAdmin < User::Admin
    # @return [String]
    def greeting
      'Hello'
    end
  end
end
