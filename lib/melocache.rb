module MeloCache

  def MeloCache.get key
    puts "redisGet"
    $redis.get key
  end

  def MeloCache.set key, value
    puts "redisSet"
    $redis.set key, value
  end


  def MeloCache.exists key
    puts "redisExists"
    $redis.exists key
  end

  def MeloCache.delete key
    puts "redisDelete"
    $redis.del key
  end

  def MeloCache.ping
    $redis.ping
  end

end