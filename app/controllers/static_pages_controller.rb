require './lib/dbquery'

class StaticPagesController < ApplicationController

  def index
  end

  def search
    @query = params[:q]
    @artists = Musicbrainz_db.search("artist", @query)
    @albums = Musicbrainz_db.search("release-group", @query)
    byebug
  end

  # TODO this should not be a static page
  def artist

    @artist = Musicbrainz_db.find("artist",params["format"])
    @name = @artist["name"]
    @country = @artist["country"]
    #@start_date = @artist.date_begin
    #@end_date = @artist.date_end
    @id = @artist["id"] # note this is the MusicBrainz-assigned id, not the rails assigned one

=begin
    # TODO this scraping is shit
    @imgpageurl = @artist.urls[:image]
    if (@imgpageurl != nil)
      doc = Nokogiri::HTML(open(@imgpageurl))
      @imgurl = doc.css('div#file').children.first.attributes["href"].value
    elsif (@artist.urls[:wikipedia] != nil)
      @imgpageurl = @artist.urls[:wikipedia]
      doc = Nokogiri::HTML(open(@imgpageurl))
      @imgurl = "https:" + doc.xpath('//table[starts-with(@class, "infobox")]').css("img").first.attributes["src"].value
    end
=end


    @release_groups = @artist["release-groups"].sort_by { |hash| hash['first-release-date']}
  end

end
