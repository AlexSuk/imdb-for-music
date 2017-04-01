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
    @band_members = get_artist_band_members(artist_relations)

    url_relations = get_artist_relations(relations, "url")
    @images = parse_relations_into_images(url_relations)
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


end
