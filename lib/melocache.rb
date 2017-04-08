module MeloCache

  def MeloCache.get key
    $redis.get key
  end

  def MeloCache.set key, value
    $redis.set key, value
  end


  def MeloCache.exists key
    $redis.exists key
  end

end