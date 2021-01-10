class ObservationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:getall, :reportstats, :put_ml_notation, :put_ml_order, :del_ml_order]
  before_action :authenticate_user!, except: [:index, :show, :getalllearn, :getall, :getallentries, :getallnot, :getallattr , :reportstats, :put_ml_notation, :put_ml_order, :del_ml_order]
  before_action :set_observation, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index, :kfold, :active_learn, :interactive_learn, :getalllearn, :getall, :getallentries, :getallnot, :getallattr, :reportstats, :put_ml_notation, :put_ml_order, :del_ml_order]

  # GET /observations
  # GET /observations.json
  def index
    @observations = Observation.where(:dataset_id => params["dataset_id"]).includes(:attr_values)
    @dataset = Dataset.find(id=params["dataset_id"])
    render layout: "dataset"
  end

  def getalllearn
    @observations = Observation.where(active_learn: true).or(Observation.where(interactive_learn: true))
    respond_to do |format|
      format.json { render json: @observations }
    end
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  def getall
    @observation = Observation.find(id=params["observation_id"])
    @notations = Notation.where(observation: @observation)
    @entries = Entry.where(dataset_id: @observation.dataset_id).includes(:ml_feature).references(:ml_feature)
    #              .joins("LEFT JOIN (#{sub_query}) as t0 on entries.id = t0.entry_id").select("*").all
    # how to include subquery.......
    # chagne this to loop
    # TODO need to understand how serialization works
    # TODO need to understand how this fucking active record thing works...

    #serial = @entries.as_json
    

    respond_to do |format|
      format.json { render json: @entries}
    end
  end

  def getallentries
    @observation = Observation.find(id=params["observation_id"])
    @entries = Entry.where(dataset_id: @observation.dataset_id).includes(:ml_feature).references(:ml_feature)

    respond_to do |format|
      format.json { render json: @entries, include: [:ml_feature]}
    end
  end

  def getallnot
    @observation = Observation.find(id=params["observation_id"])
    @notations = Notation.where(observation: @observation)

    respond_to do |format|
      format.json { render json: @notations, include: [:attr_value]}
    end
  end

  def getallattr
    @observation = Observation.find(id=params["observation_id"])
    @attr = AttrValue.where(observation: @observation)

    respond_to do |format|
      format.json { render json: @attr}
    end
  end
  # GET /observations/new
  def new
    @observation = Observation.new
    @dataset = Dataset.find(id=params["dataset_id"])
    authorize @observation
    render layout: "dataset"
  end

  def put_active_learn
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    @observation.active_learn = true
    @observation.min_notations = params["min_notations"].to_i
    @observation.save
    redirect_to proc { dataset_inference_url(@observation.dataset) }
  end

  def put_interactive_learn
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    @observation.interactive_learn = true
    @observation.min_notations = params["min_notations"].to_i
    @observation.save
    redirect_to proc { dataset_inference_url(@observation.dataset) }
  end

  def active_learn
    @observation = Observation.find(id=params["observation_id"])
    @dataset = @observation.dataset
    render layout: "dataset"
  end

  def interactive_learn
    @observation = Observation.find(id=params["observation_id"])
    @dataset = @observation.dataset
    render layout: "dataset"
  end

  def put_ml_notation
    @observation = Observation.find(id=params["observation_id"])
    @ml_notation = MlNotation.where(entry_id: params["entry_id"], observation_id: params["observation_id"]).first_or_initialize
    attributes = {
      entry_id: params["entry_id"].to_i,
      attr_value_id: params["attr_value"].to_i,
      observation_id: params["observation_id"].to_i
    }
    respond_to do |format|
      if @ml_notation.update(attributes)
        format.json { render json: @ml_notation }
      end
    end
  end

  def put_ml_order
    @ml_order = MlOrder.where(entry_id: params["entry_id"], observation_id: params["observation_id"]).first_or_initialize
    attributes = {
      entry_id: params["entry_id"].to_i,
      order: params["order"].to_i,
      observation_id: params["observation_id"].to_i
    }
    respond_to do |format|
      if @ml_order.update(attributes)
        format.json { render json: @ml_order }
      end
    end
  end

  def del_ml_order
    @ml_order = MlOrder.where(entry_id: params["entry_id"], observation_id: params["observation_id"]).first_or_initialize
    attributes = {
      entry_id: params["entry_id"].to_i,
      order: nil,
      observation_id: params["observation_id"].to_i
    }
    respond_to do |format|
      if @ml_order.update(attributes)
        format.json { render json: @ml_order }
      end
    end
  end    


  def kfold
    @observation = Observation.find(id=params["observation_id"])
    @dataset = @observation.dataset
    render layout: "dataset"
  end

  def put_kfold
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    kfold = params["kfold"].to_i
    if kfold >= 2
      @observation.k_fold = kfold
    else
      @observation.k_fold = nil
    end
    respond_to do |format|
      if @observation.save
        format.html { redirect_to dataset_inference_url(@observation.dataset), notice: 'Observation was successfully updated.' }
      end
    end
  end

  def delete_kfold
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    @observation.k_fold = nil
    respond_to do |format|
      if @observation.save
        format.html { redirect_to dataset_inference_url(@observation.dataset), notice: 'Observation was successfully updated.' }
      end
    end
  end


  def reportstats
    @observation = Observation.find(id=params["observation_id"])

    @observation.accuracy = params["acc"]
    @observation.f1_score = params["f1_score"]
    @observation.last_run = Time.now

    respond_to do |format|
      if @observation.save
        format.json { render json: @observation}
      end
    end
  end

  def delete_interactive_learn
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    @observation.interactive_learn = nil
    respond_to do |format|
      if @observation.save
        format.html { redirect_to dataset_inference_url(@observation.dataset), notice: 'Observation was successfully updated.' }
      end
    end
  end

  def delete_active_learn
    @observation = Observation.find(id=params["observation_id"])
    authorize @observation
    @observation.active_learn = nil
    respond_to do |format|
      if @observation.save
        format.html { redirect_to dataset_inference_url(@observation.dataset), notice: 'Observation was successfully updated.' }
      end
    end
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
        format.html { redirect_to dataset_observations_url(@observation.dataset), notice: 'Observation was successfully created.' }
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
