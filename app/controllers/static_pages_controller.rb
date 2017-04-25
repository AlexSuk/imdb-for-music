require './lib/dbquery'
require './lib/searchmodule'

class StaticPagesController < ApplicationController

  # home page
  def index

  end

  # search results page
  def search
    @query = params[:q]
    @artists = SearchModule.search("artist", @query)
    @albums = SearchModule.search("release-group", @query)
    @recordings = SearchModule.search("recording", @query)
  end

end
