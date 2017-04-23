require 'lib/artist'
require 'lib/release_group'
require 'lib/recording'

class CatalogController < ApplicationController

  def artist
    @artist = Artist.new(params["format"])
    @posts = Post.where("mbid = ?", @artist.id).paginate(page: params[:page])
  end

  def release_group
    @release_group = ReleaseGroup.new(params["format"])
  end

  def recording
    @recording = Recording.new(params["format"])
  end

end
