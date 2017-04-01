require './lib/dbquery'
#require './app/helpers/artist_helper.rb'

class CatalogController < ApplicationController

  def artist
    artist = Musicbrainz_db.find("artist",params["format"])
    @type = artist["type"]
    @name = artist["name"]
    @country = artist["country"]
    @id = artist["id"] # note this is the MusicBrainz-assigned id, not the rails assigned one
    @release_groups = artist["release-groups"].sort_by { |hash| hash['first-release-date']}

    relations = artist["relations"]
    artist_relations = get_artist_relations(relations, "artist")
    url_relations = get_artist_relations(relations, "url")

    @band_members = get_artist_band_members(artist_relations)



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

  private

  # Get specified relations of Artist data
  # @param {Iterable} relations A hash of all relations to sift through
  # @param {String} type The relation type to look for
  def get_artist_relations relations, type
    arr = []
    relations.each do |relation|
      if relation["target-type"] == type
        arr << relation
      end
    end
    return arr
  end

  # Get band members for a list of Artist Relations
  # @param {Iterable} artist_relations The collection of Artist Relations to sift through
  def get_artist_band_members artist_relations
    hash = {:current => [], :former => []}
    artist_relations.each do |relation|
      if relation["type"] == "member of band" && relation["ended"]
        hash[:former] << relation
      elsif relation["type"] == "member of band" && !relation["ended"]
        hash[:current] << relation
      end
    end
    return hash
  end

end
