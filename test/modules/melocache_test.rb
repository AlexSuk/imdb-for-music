require 'minitest/autorun'
require 'minitest/spec'
require_relative '../../lib/melocache.rb'


describe "Redis tests" do
  it "checks redis is running" do
  	(MeloCache.ping).must_equal "PONG"
  end
  it "checks key does not exists in redis" do
  	rand_key = rand(1000000000)
  	(MeloCache.exists rand_key).must_equal false
  end
  it "checks if some key exists in redis" do
  	rand_key = rand(1000000000)
  	(MeloCache.exists rand_key).must_equal false
  	(MeloCache.set rand_key, "test").must_equal "OK"
  	(MeloCache.exists rand_key).must_equal true
  	(MeloCache.get rand_key).must_equal "test"
  	(MeloCache.delete rand_key).must_equal 1
  	(MeloCache.exists rand_key).must_equal false
  end
end