class ReleaseGroupsController < ApplicationController
  before_action :set_release_group, only: [:show, :edit, :update, :destroy]

  # GET /release_groups
  # GET /release_groups.json
  def index
    @release_groups = ReleaseGroup.all
  end

  # GET /release_groups/1
  # GET /release_groups/1.json
  def show
  end

  # GET /release_groups/new
  def new
    @release_group = ReleaseGroup.new
  end

  # GET /release_groups/1/edit
  def edit
  end

  # POST /release_groups
  # POST /release_groups.json
  def create
    @release_group = ReleaseGroup.new(release_group_params)

    respond_to do |format|
      if @release_group.save
        format.html { redirect_to @release_group, notice: 'Release group was successfully created.' }
        format.json { render :show, status: :created, location: @release_group }
      else
        format.html { render :new }
        format.json { render json: @release_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /release_groups/1
  # PATCH/PUT /release_groups/1.json
  def update
    respond_to do |format|
      if @release_group.update(release_group_params)
        format.html { redirect_to @release_group, notice: 'Release group was successfully updated.' }
        format.json { render :show, status: :ok, location: @release_group }
      else
        format.html { render :edit }
        format.json { render json: @release_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /release_groups/1
  # DELETE /release_groups/1.json
  def destroy
    @release_group.destroy
    respond_to do |format|
      format.html { redirect_to release_groups_url, notice: 'Release group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_release_group
      @release_group = ReleaseGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def release_group_params
      params.require(:release_group).permit(:name, :record_label, :image_url)
    end
end
