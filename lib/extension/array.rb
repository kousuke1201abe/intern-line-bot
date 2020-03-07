class Array
  def match_letters?(beats)
    beats.inject(:+) == inject(0) { |sum, hash| sum + hash[:letters] }
  end

  def match_beat?(beat)
      dup.each.inject(0) do |res, hash|
        shift
        res += hash[:letters]
        return true if res == beat && hash[:pos] != "接頭詞"
        res
      end
  end
end
