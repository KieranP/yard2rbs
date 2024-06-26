class Sample
  class User
    # @return [String]
    def greeting
      "Hello"
    end

    class Admin < self
      # @return [String]
      def greeting
        "Hello"
      end
    end

    class Superadmin < Admin
      # @return [String]
      def greeting
        "Hello"
      end
    end
  end

  class Manager < User
    # @return [String]
    def greeting
      "Hello"
    end
  end
end
