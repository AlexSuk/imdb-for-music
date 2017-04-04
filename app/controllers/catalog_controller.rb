require './lib/dbquery'
require 'lib/artist'
require 'set'

class CatalogController < ApplicationController

  def artist
    mbid = params["format"]
    @artist = Artist.new(mbid)
=begin
    artist = Musicbrainz_db.find("artist",params["format"])
    @type = artist["type"]
    @name = artist["name"]
    @country = artist["country"]
    @id = artist["id"] # note this is the MusicBrainz-assigned id, not the rails assigned one
    @release_groups = artist["release-groups"].sort_by { |hash| hash['first-release-date']}

    relations = artist["relations"]
    artist_relations = get_artist_relations(relations, "artist")
    # TODO only get band members for Groups
    @band_members = get_artist_band_members(artist_relations)

    # TODO get associated acts for Persons

    url_relations = get_artist_relations(relations, "url")
    @images = parse_relations_into_images(url_relations)
=end
  end

  def release_group
    release_group = Musicbrainz_db.find("release-group",params["format"])
    @id = release_group["id"]
    @release_date = release_group["first-release-date"]
    @name = release_group["title"]
    @artist = release_group["artist-credit"].first["artist"]
    images = Musicbrainz_db.get_cover_art(@id)["images"]
    if (images != nil)
      @largeimgurl = images.first["thumbnails"]["large"]
    else
      @largeimgurl = 'http://djpunjab.in/cover.jpg'
    end

    releases = release_group["releases"]
    @tracklist = get_best_release(releases)["media"].first["tracks"]
  end

  def recording
    recording = Musicbrainz_db.find("recording", params["format"])
    @name = recording["title"]
    @artist = recording["artist-credit"].first["artist"]
    @unique_releases = get_unique_releases_for_recording(recording["releases"])
  end

  private

  # RELEASE GROUP PAGE

  # Get the most suitable release data to display on release_group view
  # TODO this could be better, more inclusive AND NEEDS TO BE FASTER
  # @param {Iterable} releases The collection of releases to sift through
  def get_best_release releases
    max_tracks = 0
    rel = nil
    releases.each do |release|
      # get all tracks of this release
      # TODO do not make this many requests to mb this fast
      release = Musicbrainz_db.find("release", release["id"])
      track_count = release["media"].first["track-count"]
      if (track_count > max_tracks)
        max_tracks = track_count
        rel = release
      end
      # if this release has the most tracks, make it the best one
    end
    return rel
  end

  # RECORDING PAGE

  # Get all unique releases for a recording, given a list of releases that recording appears on
  # @param {Iterable} releases The collections of releases to sift through
  def get_unique_releases_for_recording releases
    unique_titles = Set.new
    unique_releases = []
    releases.each do |release|
      titles_count_old = unique_titles.count
      unique_titles.add(release["title"])
      titles_count_new = unique_titles.count
      if titles_count_new != titles_count_old
        unique_releases << release["release-group"]
      end
    end
    return unique_releases
  end


end
