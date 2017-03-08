require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase

  describe Release do
    it "Release needs a name and mbid to be valid" do
      r = Release.new(name: "Release")
      r.valid?.must_equal false
    end
  end
end
