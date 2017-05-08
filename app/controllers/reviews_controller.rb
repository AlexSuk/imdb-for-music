class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  def write_review
    @review = Review.where("reviews.user_id = ? AND reviews.link = ?", "#{params[:user_id]}","#{params[:link]}" ).first
    puts 'WRITE REVIEW HERE'
    puts @review
    if @review.nil?
      puts "Creating NEW REVIEW"
      @review = Review.new
      @review.user_id = params[:user_id]
      @review.link = params[:link]
      @review.m_category = params[:m_category]
      @review.name = params[:name]
    end
    #redirect_to '/reviews/show'
    #redirect_to controller: 'reviews', action: 'show', review: @review, user_id: params[:user_id],
  end
  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.where("reviews.user_id = ? AND reviews.link = ?", "#{review_params[:user_id]}","#{review_params[:link]}" ).first
    if @review.nil?
      @review = Review.new
      @review.user_id = review_params[:user_id]
      @review.link = review_params[:link]
      @review.m_category = review_params[:m_category]
      @review.name = review_params[:name]
      @review.rating = review_params[:rating]
      @review.review = review_params[:review]
      respond_to do |format|
        if @review.save
          format.html { redirect_to @review.link, notice: 'Review was successfully created.' }
          #format.json { render :show, status: :created, location: @review }
        else
          format.html { render :new }
          format.json { render json: @review.errors, status: :unprocessable_entity }
        end
      end
    else
        @review.rating = review_params[:rating]
        @review.review = review_params[:review]
        respond_to do |format|
          if @review.save
            format.html { redirect_to @review.link, notice: 'Review was successfully updated.' }
            format.json { render :show, status: :ok, location: @review }
          else
            format.html { render :edit }
            format.json { render json: @review.errors, status: :unprocessable_entity }
          end
        end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:review, :rating, :name, :link, :user_id, :m_category)
    end
end
