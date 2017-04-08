require 'minitest/autorun'
require 'minitest/spec'
require_relative '../../lib/dbquery.rb'

#This test set is designed to test the Musicbrainz querying module stored in dbquery.rb

describe "Musicbrainz remote querying" do
  it "can remotely connect via http to Musicbrainz db" do
  	path = "release/?query=recording=fuel"
  	response = Musicbrainz_db.http_req path
  	response.must_be_instance_of(Net::HTTPOK)
    response.code.must_equal "200"
  end
  it "can search for an artist" do
  	response = Musicbrainz_db.search "artist","metallica"
  	response.must_be_instance_of(Array)
  	response[0]["name"].must_equal "Metallica"
  	response[0]["id"].must_equal "65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	response[0]["type"].must_equal "Group"
  end
  it "can search for a recording" do
  	response = Musicbrainz_db.search "recording","master of puppets"
  	response.must_be_instance_of(Array)
  	response[0]["title"].must_equal "Master of Puppets"
  	response[0]["id"].must_equal "57a1a41b-8ced-428c-96ff-6b1880587dbf"
  	response[0]["artist-credit"][0]["artist"]["name"].must_equal "Metallica"
  end
    it "can search for a release-group" do
  	response = Musicbrainz_db.search "release-group","the number of the beast"
  	response.must_be_instance_of(Array)
  	response[1]["title"].must_equal "The Number of the Beast"
  	response[1]["id"].must_equal "6ca3b386-23e8-30d5-927d-bbdfea1c5257"
  	response[1]["artist-credit"][0]["artist"]["name"].must_equal "Iron Maiden"
  end
  it "can search for an album" do
  	response = Musicbrainz_db.search "release","Opus Eponymous"
  	response.must_be_instance_of(Array)
  	response[0]["title"].must_equal "Opus Eponymous"
  	response[0]["id"].must_equal "76c94c2c-2a50-4e19-b20a-f687c5311796"
  	response[0]["artist-credit"][0]["artist"]["name"].must_equal "Ghost"
  end
  it "can find a specific artist by id" do
  	response = Musicbrainz_db.find "artist","65f4f0c5-ef9e-490c-aee3-909e7ae6b2ab"
  	response.must_be_instance_of(Hash)
  	response["name"].must_equal "Metallica"
  end
    it "can find a recording by id" do
  	response = Musicbrainz_db.find "recording","57a1a41b-8ced-428c-96ff-6b1880587dbf"
  	response.must_be_instance_of(Hash)
  	response["artist-credit"][0]["name"].must_equal "Metallica"
  end
  it "can find a specific release-group by id" do
	response = Musicbrainz_db.find "release-group","6ca3b386-23e8-30d5-927d-bbdfea1c5257"
	response.must_be_instance_of(Hash)
  	response["artist-credit"][0]["name"].must_equal "Iron Maiden"
  end
end
