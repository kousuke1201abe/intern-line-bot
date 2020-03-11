class MatsuoBasho
  attr_reader :haiku

  def initialize(*haiku)
    @haiku = haiku
  end

  def reply_message
    kigo.present? ? "#{message}\n\n季語は「#{kigo}」だな\u{1F4AE}" : message
  end

  def message
    @message ||=
      <<~EOS.chomp
        #{haiku.join("\n\n")}
      EOS
  end

  def kigo
    @kigo ||=
      Widget.where("'#{haiku.join}' ~ name").pluck(:name).join(", ")
  end
end
