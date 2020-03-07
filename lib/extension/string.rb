class String
  def delete_contracted_sound
    gsub(/[ゃ]|[ゅ]|[ょ]|[ゎ][ぇ]|[ヮ]|[ャ]|[ョ]|[ュ]|[ェ]/, "")
  end
end
