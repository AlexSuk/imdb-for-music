require 'test_helper'

class TrackTest < ActiveSupport::TestCase

  describe "Track" do
    it "Track needs a name and release_id to be valid" do
      t = Track.new(name: "Track")
      t.valid?.must_equal false
    end
  end

end
