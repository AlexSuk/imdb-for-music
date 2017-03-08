require 'test_helper'

class ReleaseGroupTest < ActiveSupport::TestCase

  describe ReleaseGroup do
    it "ReleaseGroup needs a name and mbid to be valid" do
      rg = ReleaseGroup.new(name: "Release Group")
      rg.valid?.must_equal false
    end
  end

end
