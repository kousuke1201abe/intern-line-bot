class MatsuoBasho
  attr_reader :phrase

  ALLOWED_POS_MAP = ["名詞", "動詞", "形容詞", "形容動詞", "副詞", "連体詞", "接続詞", "感動詞", "接頭詞", "フィラー"]
  HAIKU_MESSAGE_MAP = ["俳句じゃん\u{261D}", "五七五\u{1F4AE}", "よっ俳人\u{1F61A}"]

  def initialize(phrase:)
    @phrase = phrase
  end

  def senryu?
    match_beats?(5, 7, 5)
  end

  def haiku?
    kigo.present? && match_beats?(5, 7, 5)
  end

  def tanka?
    match_beats?(5, 7, 5, 7, 7)
  end

  def kigo
    Widget.pluck(:name).map { |name| phrase.scan(name).first }.compact.join(",")
  end

  def message(symbol)
    {
      type: 'text',
      text: text(symbol)
    }
  end

  def text(symbol)
    if symbol == :haiku
      text_for_haiku.chomp!
    elsif symbol == :senryu
      "それ川柳ね\u{1F91A}"
    elsif symbol == :tanka?
      "それ短歌ね\u{1F91A}"
    end
  end

  def text_for_haiku
    <<~EOS
      #{HAIKU_MESSAGE_MAP.sample}
      季語 #{kigo}
    EOS
  end

  private

  def match_beats?(*beats)
    return false unless mecab_array.match_letters?(beats)

    arr = mecab_array
    beats.all? do |beat|
      return false unless arr.first.present?
      return false unless ALLOWED_POS_MAP.include?(arr.first[:pos])

      arr.match_beat?(beat)
    end
  end

  def mecab_array
    arr = Array.new
    Natto::MeCab.new.parse(phrase) do |mecab_node|
      unless mecab_node.is_eos? || mecab_node.pos == "記号" || mecab_node.feature.split(",").last == "*"
        arr << { pos: mecab_node.pos, letters: mecab_node.letters }
      end
    end
    arr
  end
end
