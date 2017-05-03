require './lib/dbquery'

class ReleaseGroup

  def initialize(mbid)
    @release_group_data = SearchModule.find("release-group", mbid)
  end

  def id
    return @release_group_data["id"]
  end

  def name
    return @release_group_data["title"]
  end

  def release_date
    return @release_group_data["first-release-date"]
  end

  def artist
    return @release_group_data["artist-credit"].first["artist"]
  end

  def type
    return @release_group_data["primary-type"]
  end

  # Return album cover; if no cover found, return image with "Not found"
  def image
    #images = Musicbrainz_db.get_cover_art(self.id)["images"]

    images = SearchModule.get_cover_art(self.id)
    if images != nil
      return images["images"].first["thumbnails"]["large"]
    else
      return 'http://djpunjab.in/cover.jpg'
    end
  end

  # Return album tracklist JSON data
  def tracklist
    releases = @release_group_data["releases"]
    if releases.count > 0
      return get_best_release(releases)["media"].first["tracks"]
    else
      return []
    end
  end

  private

  # Get the most suitable release data to display on release_group view
  # TODO this could be better, more inclusive AND NEEDS TO BE FASTER
  # @param {Iterable} releases The collection of releases to sift through
  def get_best_release releases
    max_tracks = 0
    rel = nil
    releases.each do |release|
      # get all tracks of this release
      # TODO do not make this many requests to mb this fast
      #release = Musicbrainz_db.find("release", release["id"])
      release = SearchModule.find("release", release["id"])
      if !release["media"].nil?
        track_count = release["media"].first["track-count"]
       if (track_count > max_tracks)
          max_tracks = track_count
          rel = release
       end
     end
      # if this release has the most tracks, make it the best one
    end
    return rel
  end

end
