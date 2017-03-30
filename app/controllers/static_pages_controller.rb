require './lib/dbquery'

class StaticPagesController < ApplicationController

  # home page
  def index

  end

  # search results page
  def search
    @query = params[:q]
    @artists = Musicbrainz_db.search("artist", @query)
    @albums = Musicbrainz_db.search("release-group", @query)
  end

end
