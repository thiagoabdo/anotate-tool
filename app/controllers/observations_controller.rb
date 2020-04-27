class ObservationsController < ApplicationController
  before_action :set_observation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  after_action :verify_authorized, except: :index

  # GET /observations
  # GET /observations.json
  def index
    @observations = Observation.where(:dataset_id => params["dataset_id"])
    @dataset = Dataset.find(id=params["dataset_id"])
    render layout: "dataset"
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  # GET /observations/new
  def new
    @observation = Observation.new
    @dataset = Dataset.find(id=params["dataset_id"])
    authorize @observation
    render layout: "dataset"
  end

  # GET /observations/1/edit
  def edit
    @dataset = @observation.dataset
  end

  # POST /observations
  # POST /observations.json
  def create
    @observation = Observation.new(observation_params)
    authorize @observation

    respond_to do |format|
      if @observation.save
        format.html { redirect_to @observation, notice: 'Observation was successfully created.' }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /observations/1
  # PATCH/PUT /observations/1.json
  def update
    respond_to do |format|
      if @observation.update(observation_params)
        format.html { redirect_to @observation, notice: 'Observation was successfully updated.' }
        format.json { render :show, status: :ok, location: @observation }
      else
        format.html { render :edit }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to observations_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_observation
      @observation = Observation.find(params[:id])
      authorize @observation
    end

    # Only allow a list of trusted parameters through.
    def observation_params
      params.require(:observation).permit(:name, :dataset_id, attr_values_attributes: [:_destroy, :value, :id])
    end
end
