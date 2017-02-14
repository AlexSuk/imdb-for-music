
class SearchController < ApplicationController

  def index
  end

  def search
    @query = params[:q]
    @artists = MusicBrainz::Artist.search(@query)
    @albums = MusicBrainz::ReleaseGroup.search("", @query)
  end

  def artist

    @artist = MusicBrainz::Artist.find(params["format"])
    @name = @artist.name
    @country = @artist.country
    @start_date = @artist.date_begin
    @end_date = @artist.date_end
    @id = @artist.id

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



    @release_groups = @artist.release_groups
  end

end
