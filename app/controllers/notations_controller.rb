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
    @notations = Notation.where(:user_id => current_user.id)
    @dataset = params[:dataset_id]
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
    @observation = Observation.find(params[:observation_id])
    #@entry = Entry.where(:dataset_id =>params[:dataset_id]).where.not(:id => Notation.from_user_obs(current_user.id,params[:observation_id]).select(:entry_id)).first  
    sub_query = Notation.from_user_obs(current_user.id, params[:observation_id]).to_sql
    @entry = Entry.joins("LEFT JOIN (#{sub_query}) as t0 on entries.id = t0.entry_id").where(t0: {entry_id: nil}).first
    if !@entry
      redirect_to dataset_choose_class_url(@dataset), notice: 'Classe completamente anotada por voce'
      return
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
    @notation = Notation.new(notation_params)
    d = @notation.observation.dataset_id
    c = @notation.observation_id
    respond_to do |format|
      if @notation.save
        format.html { redirect_to new_dataset_observation_notation_url(d, c), notice: 'Notation was successfully created.' }
        format.json { render :show, status: :created, location: @notation }
      else
        format.html { render :new }
        format.json { render json: @notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notations/1
  # PATCH/PUT /notations/1.json
  def update
    respond_to do |format|
      if @notation.update(notation_params)
        format.html { redirect_to @notation, notice: 'Notation was successfully updated.' }
        format.json { render :show, status: :ok, location: @notation }
      else
        format.html { render :edit }
        format.json { render json: @notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notations/1
  # DELETE /notations/1.json
  def destroy
    @notation.destroy
    respond_to do |format|
      format.html { redirect_to notations_url, notice: 'Notation was successfully destroyed.' }
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
      params.require(:notation).permit(:attr_value_id, :user_id, :entry_id, :observation_id)
    end
end
