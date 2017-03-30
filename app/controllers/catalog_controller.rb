require './lib/dbquery'

class CatalogController < ApplicationController

  def artist
    artist = Musicbrainz_db.find("artist",params["format"])
    byebug
    @name = artist["name"]
    @country = artist["country"]
    @id = artist["id"] # note this is the MusicBrainz-assigned id, not the rails assigned one
    @release_groups = artist["release-groups"].sort_by { |hash| hash['first-release-date']}
  end

  def release_group
    release_group = Musicbrainz_db.find("release-group",params["format"])
    @id = release_group["id"]
    @name = release_group["title"]
    @artist = release_group["artist-credit"].first["artist"]["name"]
    images = Musicbrainz_db.get_cover_art(@id)["images"]
    if (images != nil)
      @largeimgurl = images.first["thumbnails"]["large"]
    else
      @largeimgurl = 'http://djpunjab.in/cover.jpg'
    end
  end

  def recording
  end

end
