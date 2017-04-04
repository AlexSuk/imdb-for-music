require 'lib/artist'
require 'lib/release_group'
require 'lib/recording'

class CatalogController < ApplicationController

  def artist
    mbid = params["format"]
    @artist = Artist.new(mbid)
  end

  def release_group
    mbid = params["format"]
    @release_group = ReleaseGroup.new(mbid)
  end

  def recording
    mbid = params["format"]
    @recording = Recording.new(mbid)
  end

end
