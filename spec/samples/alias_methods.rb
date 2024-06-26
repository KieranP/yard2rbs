class Sample
  # @return [String]
  def greeting1a
    "Hello!"
  end

  # @return [String]
  def greeting2a
    "Greetings!"
  end

  # @return [String]
  def greeting3a
    "Welcome!"
  end

  alias_method :greeting1b, :greeting1a
  alias :greeting2b :greeting2a
  alias greeting3b greeting3a
end
