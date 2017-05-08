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
    @avgRating = Review.where("reviews.link = ?", "/release-group.#{@release_group.id}").average(:rating)
    @userRating = Review.where("reviews.link = ? AND reviews.user_id = ?", "/release-group.#{@release_group.id}", session[:user_id]).pluck(:rating).first
    if @avgRating.nil?
      @avgRating = "Not Rated"
    else
      @avgRating = @avgRating.round(1)
    end
    if @userRating.nil?
      @userRating = "Not Rated"
    end
    @reviews = Review.where("reviews.link = ?", "/release-group.#{@release_group.id}")
  end

  def recording
    @recording = Recording.new(params["format"])
    @avgRating = Review.where("reviews.link = ?", "/recording.#{@recording.id}").average(:rating)
    @userRating = Review.where("reviews.link = ? AND reviews.user_id = ?", "/recording.#{@recording.id}", session[:user_id]).pluck(:rating).first
    if @avgRating.nil?
      @avgRating = "Not Rated"
    else
      @avgRating = @avgRating.round(1)
    end
    if @userRating.nil?
      @userRating = "Not Rated"
    end
    @reviews = Review.where("reviews.link = ?", "/recording.#{@recording.id}")
  end

end
