class NotationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:get_all_notations]
  before_action :set_notation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :get_all_notations]

  # GET /notations
  # GET /notations.json
  def index
    @notations = Notation.all
    @dataset = Dataset.find(params["dataset_id"])
    render layout: "dataset"
  end

  def my_notations
    @dataset = Dataset.find(params["dataset_id"])
    @notations = Notation.where(:user_id => current_user.id).where(:observation_id => @dataset.observations)
    render layout: "dataset"
  end

  # GET /notations/1
  # GET /notations/1.json
  def show
  end

  # GET /notations/new
  def new
    @notation = Notation.new
    @dataset = params[:dataset_id]
    @per_example = params[:observation_id] == "0"
    if params[:observation_id] == "0"
      sub_query = Notation.from_user(current_user.id).to_sql
      @entry = Entry.where(:dataset_id => params[:dataset_id]).joins("FULL JOIN observations as t0 on t0.dataset_id = entries.dataset_id").joins("LEFT JOIN (#{sub_query}) as t1 on entries.id = t1.entry_id and t0.id = t1.observation_id").where(t1: {entry_id: nil}).first
      @observation = Observation.where(:dataset_id => params[:dataset_id]).joins("LEFT JOIN (#{Notation.from_user_entry(current_user.id, @entry).to_sql}) as t0 on observations.id = t0.observation_id").where(t0: {observation_id: nil}).first
      if !@entry
        redirect_to dataset_choose_class_url(@dataset), notice: 'Database completamente anotado'
        return
      end
    else
      sub_query = Notation.from_user_obs(current_user.id, params[:observation_id]).to_sql
      @observation = Observation.find(params[:observation_id])
      if @observation.active_learn
        @entry = Entry.where(:dataset_id =>params[:dataset_id]).joins("LEFT JOIN (#{sub_query}) as t0 on entries.id = t0.entry_id").where(t0: {entry_id: nil}).includes(:ml_orders).order('ml_orders.effective_order', 'ml_orders.order').first
      else
        @entry = Entry.where(:dataset_id =>params[:dataset_id]).joins("LEFT JOIN (#{sub_query}) as t0 on entries.id = t0.entry_id").where(t0: {entry_id: nil}).first
      end
      if !@entry
        redirect_to dataset_choose_class_url(@dataset), notice: 'Classe completamente anotada por voce'
        return
      end
    end

    if @observation.interactive_learn
      @ml_notation = MlNotation.where(entry_id: @entry.id, observation_id: @observation.id).first
    end
    render layout: "dataset"
  end

  # GET /notations/1/edit
  def edit
  end

  def choose
    @classes = Observation.where(:dataset_id => params[:dataset_id])
    @dataset = Dataset.find(params["dataset_id"])
    render layout: "dataset"
  end

  # POST /notations
  # POST /notations.json
  def create
    per_example = params[:notation][:anotate_per_example]
    @notation = Notation.new(notation_params)
    d = @notation.observation.dataset_id
    c = @notation.observation_id
    e = @notation.entry_id

    respond_to do |format|
      if @notation.save
        MlOrder.transaction do
          @ml_order = MlOrder.where(:entry_id => e, :observation_id => c).first_or_initialize
          max_effective_order = MlOrder.where(:observation_id => c).maximum(:effective_order)
          if max_effective_order.nil?
            max_effective_order = 0
          end
          @ml_order.effective_order = max_effective_order + 1
          @ml_order.save!
        end
        puts(per_example)
        if per_example == "true"
          format.html { redirect_to new_dataset_observation_notation_url(d, 0), notice: 'Notation was successfully created.' }
          format.json { render :show, status: :created, location: @notation }
        else
          format.html { redirect_to new_dataset_observation_notation_url(d, c), notice: 'Notation was successfully created.' }
          format.json { render :show, status: :created, location: @notation }
        end
      else
        format.html { render :new }
        format.json { render json: @notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notations/1
  # PATCH/PUT /notations/1.json
  def update
    d = @notation.observation.dataset_id
    respond_to do |format|
      if @notation.update(notation_params)
        format.html { redirect_to dataset_mynotations_url(d), notice: 'Notation was successfully updated.' }
        format.json { render :show, status: :ok, location: @notation }
      else
        format.html { render :edit }
        format.json { render json: dataset_mynotations_url(d).errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notations/1
  # DELETE /notations/1.json
  def destroy
    d = @notation.observation.dataset_id
    @notation.destroy
    respond_to do |format|
      format.html { redirect_to dataset_mynotations_url(d), notice: 'Notation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notation
      @notation = Notation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notation_params
      params[:notation].delete(:anotate_per_example)
      params.require(:notation).permit(:attr_value_id, :user_id, :entry_id, :observation_id)
    end
end
