class MatsuoBasho
  attr_reader :haiku

  def initialize(*haiku)
    @haiku = haiku
  end

  def reply_message
    message
  end

  def message
    @message ||=
      <<~EOS.chomp
        #{haiku.join("\n\n")}
      EOS
  end
end
