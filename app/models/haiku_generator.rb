class HaikuGenerator
  attr_reader :phrase

  ALLOWED_POS_MAP = ["名詞", "動詞", "形容詞", "形容動詞", "副詞", "連体詞", "接続詞", "感動詞", "接頭詞", "フィラー"]

  def self.generate(phrase:)
    hash_map = Array.new
    Natto::MeCab.new.parse(phrase) do |mecab_node|
      unless mecab_node.surface != "。" && mecab_node.feature.split(",").first == "記号" || mecab_node.is_eos? || mecab_node.feature.split(",").last == "*" || mecab_node.surface == "％"
        hash_map << {
          pos: mecab_node.feature.split(",").first,
          letters: mecab_node.feature.split(",").last.gsub(/[ゃ]|[ゅ]|[ょ]|[ゎ][ぇ]|[ヮ]|[ャ]|[ョ]|[ュ]|[ェ]|[ァ]|[ぁ]|[ぃ]|[ィ]|[ぅ]|[ゥ]|[ぉ]|[ォ]/, "").length,
          surface: mecab_node.surface,
          conjugation: mecab_node.feature.split(",")[-4],
        }
      end
    end
    is_break = false
    count = 0
    temp = []
    temp2 = []
    temp3 = []
    res = []
    hash_map.each.with_index do |_, i|
      is_break = false
      hash_map.each.with_index do |_, j|
        if hash_map[i+j].nil? || hash_map[i+j][:surface] == "。" || hash_map[i+j][:surface].include?("０")
          is_break = true
        end
        break if is_break
        break if hash_map[i+j].nil?
        count += hash_map[i+j][:letters]
        temp << { surface: hash_map[i+j][:surface], pos: hash_map[i+j][:pos] }
        if count == 5
          if !["名詞", "形容詞", "形容動詞", "副詞", "連体詞", "感動詞", "接頭詞"].include?(temp[0][:pos]) || temp[-1][:pos] == "接頭詞" || temp[-1][:surface][-1] == "っ"
            is_break = true and break
          end
          temp2 << temp
          temp = []
          hash_map.each.with_index do |_, k|
            if hash_map[i+j+k+1].nil? || hash_map[i+j+k+1][:surface] == "。" || hash_map[i+j+k+1][:surface].include?("０")
              is_break = true
            end
            break if is_break
            count += hash_map[i+j+k+1][:letters]
            temp << { surface: hash_map[i+j+k+1][:surface], pos: hash_map[i+j+k+1][:pos] }
            if count == 12
              if !["名詞", "動詞", "形容詞", "形容動詞", "副詞", "連体詞", "接続詞", "感動詞", "接頭詞", "フィラー"].include?(temp[0][:pos]) || temp[-1][:pos] == "接頭詞" || temp[-1][:surface][-1] == "っ"
                is_break = true and break
              end
              temp2 << temp
              temp = []
              hash_map.each.with_index do |_, l|
                if hash_map[i+j+k+l+2].nil? || hash_map[i+j+k+l+2][:surface] == "。" || hash_map[i+j+k+l+2][:surface].include?("０")
                  is_break = true
                end
                break if is_break
                count += hash_map[i+j+k+l+2][:letters]
                temp << { surface: hash_map[i+j+k+l+2][:surface], pos: hash_map[i+j+k+l+2][:pos], conjugation: hash_map[i+j+k+l+2][:conjugation] }
                if count == 17 || count == 17
                  if !["名詞", "動詞", "形容詞", "形容動詞", "副詞", "連体詞", "接続詞", "感動詞", "接頭詞", "フィラー"].include?(temp[0][:pos]) || !["名詞", "動詞"].include?(temp[-1][:pos]) || temp[-1][:surface][-1] == "っ" || ["未然形", "連用形", "未然レル接続"].include?(temp[-1][:conjugation])
                    is_break = true and break
                  end
                  temp2 << temp
                  temp3 = temp2.map { |s| p s.map { |a| a[:surface] }.join }.join(" ")
                  res << temp3
                  temp2 = []
                elsif count > 17
                  is_break = true
                end
              end
            elsif count > 12
              is_break = true
            end
          end
        elsif count > 5
          count = 0
          temp = []
          temp2 = []
          is_break = true
        end
      end
    end
    raise if res.blank?
    res.map! do |h|
      kigo = Widget.where("'#{h}' ~ name").pluck(:name).join(", ")
      if kigo.present?
        "#{h} (季語: #{kigo})"
      else
        h
      end
    end
    res
  end
end
