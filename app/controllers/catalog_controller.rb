require './lib/dbquery'
require 'lib/artist'
require 'lib/release_group'
require 'set'

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
    recording = Musicbrainz_db.find("recording", params["format"])
    @name = recording["title"]
    @artist = recording["artist-credit"].first["artist"]
    @unique_releases = get_unique_releases_for_recording(recording["releases"])
  end

  private

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
