require 'lib/artist'
require 'lib/release_group'
require 'lib/recording'

class CatalogController < ApplicationController

  def artist
    @artist = Artist.new(params["format"])
    @posts = Post.where("mbid = ?", @artist.id).paginate(page: params[:page])
    @bio = Wikipedia.find(@artist.wikipedia).summary.split("\n") unless @artist.wikipedia == nil
  end

  def release_group
    @release_group = ReleaseGroup.new(params["format"])
    @posts = Post.where("mbid = ?", @release_group.artist["id"]).paginate(page: params[:page])
    @ratings_hash = get_rating_data(@release_group, "release-group")
    @reviews = Review.where("reviews.link = ?", "/release-group.#{@release_group.id}")
  end

  def recording
    @recording = Recording.new(params["format"])
    @posts = Post.where("mbid = ?", @recording.artist["id"]).paginate(page: params[:page])
    @ratings_hash = get_rating_data(@recording, "recording")
    @reviews = Review.where("reviews.link = ?", "/recording.#{@recording.id}")
  end

  private

  def get_rating_data entity, type
    hash = {:avg=> nil, :user=> nil}
    avg = Review.where("reviews.link = ?", "/#{type}.#{entity.id}").average(:rating)
    user = Review.where("reviews.link = ? AND reviews.user_id = ?", "/#{type}.#{entity.id}", session[:user_id]).pluck(:rating).first
    hash[:avg] = avg == nil ? "Not Rated" : avg.round(1)
    hash[:user] = user == nil ? "Not Rated" : user
    return hash
  end

end
