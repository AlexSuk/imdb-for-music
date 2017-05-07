require 'minitest/autorun'
require 'minitest/spec'
require_relative '../../lib/searchmodule.rb'
require_relative '../../lib/melocache.rb'

describe "Sarchmodule tests" do
  after do
  	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  end
  it "Artist search test" do
  	MeloCache.delete "artistmetallica"
  	SearchModule.search "artist","metallica"
  	(MeloCache.exists "artistmetallica").must_equal true
  end

  it "Redis search delay vs Musicbrainz search delay test" do
  	MeloCache.delete "artistmetallica"
  	time_before_Musicbrainz = Time.now
  	SearchModule.search "artist","metallica"
  	time_after_Musicbrainz = Time.now
  	SearchModule.search "artist","metallica"
  	time_after_redis = Time.now
  	musicbrainz_delay = time_after_Musicbrainz-time_before_Musicbrainz
  	redis_delay = time_after_redis  - time_after_Musicbrainz
  	#we expect to have much faster access with redis than with Musicbrainz
  	musicbrainz_delay.must_be :>,redis_delay
  end

  it "Artist find test" do
  	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	SearchModule.find "artist","65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	(MeloCache.exists "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab").must_equal true
  end

  it "Redis find delay vs Musicbrainz find delay test" do
  	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_before_Musicbrainz = Time.now
  	SearchModule.find "artist","65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_after_Musicbrainz = Time.now
  	SearchModule.find "artist","65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_after_redis = Time.now
  	musicbrainz_delay = time_after_Musicbrainz-time_before_Musicbrainz
  	redis_delay = time_after_redis  - time_after_Musicbrainz
  	#we expect to have much faster access with redis than with Musicbrainz
  	musicbrainz_delay.must_be :>,redis_delay
  end
  it "Artist cover art test" do
  	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	SearchModule.find "artist","65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	SearchModule.get_cover_art "65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	(SearchModule.exists_cover_art "65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab").must_equal true
 # 	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  #	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  end

  it "Redis cover_art delay vs Musicbrainz cover_art delay test" do
  	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_before_Musicbrainz = Time.now
  	SearchModule.get_cover_art "65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_after_Musicbrainz = Time.now
  	SearchModule.get_cover_art "65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	time_after_redis = Time.now
  	musicbrainz_delay = time_after_Musicbrainz-time_before_Musicbrainz
  	redis_delay = time_after_redis  - time_after_Musicbrainz
  	#we expect to have much faster access with redis than with Musicbrainz
  	musicbrainz_delay.must_be :>,redis_delay
  #	MeloCache.delete "artist65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  #	MeloCache.delete "cover_art65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  end

end