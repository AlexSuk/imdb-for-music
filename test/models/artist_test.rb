require_relative '../test_helper'

class ArtistTest < ActiveSupport::TestCase

  describe Artist do

    before do
      Artist.destroy_all
      Artist.create(name: "Artist1", mbid: "c9f91cdc-984e-4303-9a51-4ac0dfa2348f")
    end

    it "has one Artist in database" do
      Artist.count.must_equal 1
    end

    it "can accept a new artist" do
      Artist.create(name: "Artist2", mbid: "189002e7-3285-4e2e-92a3-7f6c30d407a2")
      Artist.count.must_equal 2
    end

    it "Artist requires name and mbid to be valid" do
      a = Artist.new(name: "Artist")
      a.valid?.must_equal false
    end

    it "has mbid with length 36" do
      a = Artist.new(name: "Artist", mbid:"Thisisnot36characters")
      a.valid?.must_equal false
    end

    it "has unique mbid" do
      Artist.create(name: "SameMBID as Artist in before block", mbid: "c9f91cdc-984e-4303-9a51-4ac0dfa2348f")
      Artist.count.must_equal 1
    end

  end

end
