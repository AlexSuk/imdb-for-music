require './lib/dbquery'
require 'set'

class Recording

  def initialize(mbid)
    @recording_data = Musicbrainz_db.find("recording", mbid)
  end

  def id
    return @recording_data["id"]
  end

  def name
    return @recording_data["title"]
  end

  def artist
    return @recording_data["artist-credit"].first["artist"]
  end

  # Get all unique releases for a recording
  def unique_releases
    releases = @recording_data["releases"]
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
