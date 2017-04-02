require './lib/dbquery'
require 'set'

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
    # TODO only get band members for Groups
    @band_members = get_artist_band_members(artist_relations)

    # TODO get associated acts for Persons

    url_relations = get_artist_relations(relations, "url")
    @images = parse_relations_into_images(url_relations)
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

  # Get a collection of images for an artist, given a set of URL Relations
  # @param {Iterable} url_relations Collection of URL Relations to parse
  def parse_relations_into_images url_relations
    imgurls = []
    url_relations.each do |relation|
      puts "url relation"
      url = relation["url"]["resource"]
      case relation["type"]
      when "allmusic"
        doc = Nokogiri::HTML(open(url))
        # parse for allmusic.com
        if doc.css(".artist-image").count != 0
          imgurl = doc.css(".artist-image").children.css("img").attribute("src").value
          imgurls << imgurl
        end
        # TODO -- can we get all images in lightbox gallery?
      when "bandsintown"
        doc = Nokogiri::HTML(open(url))
        if doc.css(".sidebar-image").count != 0
          imgurl = doc.css(".sidebar-image").css("img").attribute("src").value
          imgurls << imgurl
        end
      when "discogs"
        doc = Nokogiri::HTML(open(url))
        # parse for discogs.com
        gallery_url = ""
        if doc.css(".image_gallery_more").count != 0
          gallery_url = "https://www.discogs.com" +
                      doc.css(".image_gallery_more").children.css("a").attribute("href").value
        elsif doc.css(".image_gallery").count != 0
          gallery_url = "https://www.discogs.com" +
                      doc.css(".image_gallery").css("a").attribute("href").value
        end

        if gallery_url != ""
          doc = Nokogiri::HTML(open(gallery_url))
          gallery = doc.css('[id="view_images"]').children.css("p")
          i = 0
          gallery.each do |element|
            if (element.children.css("img").count != 0)
              puts "in discogs" + i.to_s
              imgurl = element.css("img").attribute("src").value
              imgurls << imgurl
              puts imgurls
            end
            i = i + 1
          end
        end
      when "last.fm"
        # parse for last.fm
      when "myspace"
        # parse for myspace.com
      when "wikipedia"
        # parse for wikipedia
      end
    end

    return imgurls
    # check for duplicate images, maybe use phasion https://github.com/westonplatter/phashion
  end

  # TODO get artist social media, official site, etc

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
