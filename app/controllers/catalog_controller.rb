require './lib/dbquery'

class CatalogController < ApplicationController

  def artist
    artist = Musicbrainz_db.find("artist",params["format"])
    @name = artist["name"]
    @country = artist["country"]
    @id = artist["id"] # note this is the MusicBrainz-assigned id, not the rails assigned one
    @release_groups = artist["release-groups"].sort_by { |hash| hash['first-release-date']}

    relations = artist["relations"]
    @artist_relations = []
    @url_relations = []
    relations.each do |relation|
      if relation["target-type"] == "url"
        @url_relations << relation
      elsif relation["target-type"] == "artist"
        @artist_relations << relation
      end
    end

    # get band members, if there are any
    @band_members = []
    @artist_relations.each do |a_relation|
      if a_relation["type"] == "member of band"
        @band_members << a_relation
      end
    end

    byebug

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
