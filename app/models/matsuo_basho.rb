class MatsuoBasho
  attr_reader :phrase

  ALLOWED_POS_MAP = ["名詞", "動詞", "形容詞", "形容動詞", "副詞", "連体詞", "接続詞", "感動詞", "接頭詞", "フィラー"]
  HAIKU_MESSAGE_MAP = ["俳句じゃん\u{261D}", "五七五\u{1F4AE}", "よっ俳人\u{1F61A}"]

  def initialize(phrase:)
    @phrase = phrase
  end

  def haiku?
    match_beats?(5, 7, 5)
  end

  def tanka?
    match_beats?(5, 7, 5, 7, 7)
  end

  def message(symbol)
    if phrase
    {
      type: 'text',
      text: symbol == :haiku ? HAIKU_MESSAGE_MAP.sample : "それ短歌ね\u{1F91A}"
    }
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
