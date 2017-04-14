require './lib/dbquery'
require './lib/searchmodule'

class Artist

  # TODO get artist social media, official site, etc

  def initialize(mbid)
    @artist_data = SearchModule.find("artist", mbid)
    #@artist_data = Musicbrainz_db.find("artist", mbid)
  end

  # Return the MBID of this artist
  def id
    return @artist_data["id"]
  end

  # Returns the name of the artist
  def name
    return @artist_data["name"]
  end

  # Returns artist type "Group", "Person", etc
  def type
    return @artist_data["type"]
  end

  # Returns JSON data representing all release_groups of this artist
  def release_groups
    return @artist_data["release-groups"].sort_by { |hash| hash["first-release-date"]}
  end

  # Get all relation JSON data
  def relations
    return @artist_data["relations"]
  end

  # If artist.type is "Group", return band member JSON data
  # else, return nil
  def band_members
    if self.type == "Group"
      artist_relations = get_relations(self.relations, "artist")
      hash = {:current => [], :former => []}
      artist_relations.each do |relation|
        if relation["type"] == "member of band" && relation["ended"]
          hash[:former] << relation
        elsif relation["type"] == "member of band" && !relation["ended"]
          hash[:current] << relation
        end
      end
      return hash
    else
      return nil
    end
  end

  def images
    if !(SearchModule.exists_cover_art @artist_data["id"])
      @imgurls = self.images_fetch
      SearchModule.set_cover_art @artist_data["id"], @imgurls
      return @imgurls
    else
      @imgurls = SearchModule.get_cover_art @artist_data["id"]
      return @imgurls
    end
  end

  # Get image urls for this artist from url relations
  # Returns array of image urls
  # TODO limit number of images (to limit TooManyHTTPRequests errors)
  def images_fetch
    url_relations = get_relations(self.relations, "url")
    @imgurls = []
    #byebug
    url_relations.each do |relation|
      if @imgurls.count < 4
        puts "url relation"
        url = relation["url"]["resource"]
        case relation["type"]
        when "allmusic"
          doc = Nokogiri::HTML(open(url))
          # parse for allmusic.com
          if doc.css(".artist-image").count != 0
            imgurl = doc.css(".artist-image").children.css("img").attribute("src").value
            @imgurls << imgurl
          end
          # TODO -- can we get all images in lightbox gallery?
        when "bandsintown"
          doc = Nokogiri::HTML(open(url))
          if doc.css(".sidebar-image").count != 0
            imgurl = doc.css(".sidebar-image").css("img").attribute("src").value
            @imgurls << imgurl
          end

        when "discogs"
          # This site has  very low threshold for htttp request volume
#=begin
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
            if gallery.first.children.css("img").count != 0
              imgurl = gallery.first.css("img").attribute("src").value
              @imgurls << imgurl
            end
            gallery.each do |element|
              if (element.children.css("img").count != 0)
                imgurl = element.css("img").attribute("src").value
                @imgurls << imgurl
              end
            end
          end
#=end

        when "last.fm"
          # parse for last.fm
        when "myspace"
          # parse for myspace.com
        when "wikipedia"
          # parse for wikipedia
          doc = Nokogiri::HTML(open(url))
          imgurl = "https:" + doc.xpath('//table[starts-with(@class, "infobox")]').css("img").first.attributes["src"].value
          arr = imgurl.split("/")
          arr.delete("thumb")
          arr.delete_at(arr.length-1)
          arr = arr.join("/")
          imgurl = arr
          @imgurls << imgurl
        end
      end
    end

    return @imgurls
    # TODO check for duplicate images, maybe use phasion https://github.com/westonplatter/phashion
  end

  private

  # Get collection of relations of specifc type for Artist
  # @param {Iterable} relations A hash of all relations to sift through
  # @param {String} type The relation type to look for
  def get_relations relations, type
    arr = []
    relations.each do |relation|
      if relation["target-type"] == type
        arr << relation
      end
    end
    return arr
  end

end
