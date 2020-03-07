class Natto::MeCabNode
  def pos
    feature.split(",").first
  end

  def letters
    feature.split(",").last.delete_contracted_sound.length
  end
end
