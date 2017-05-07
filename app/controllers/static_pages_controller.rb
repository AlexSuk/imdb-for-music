require './lib/dbquery'
require './lib/searchmodule'

class StaticPagesController < ApplicationController

  # home page
  def index

  end

  # search results page
  def search
    @query = params[:q] + " "
    @filter = params[:filter]
    if @filter == "Artist" || @filter == "Any"
      @artists = SearchModule.search("artist", @query)
    end

    if @filter == "Release" || @filter == "Any"
      @albums = SearchModule.search("release-group", @query)
    end

    if @filter == "Recording" || @filter == "Any"
      @recordings = SearchModule.search("recording", @query)
    end
  end

  def test
  end

end
