class MlNotationsController < ApplicationController
  before_action :set_ml_notation, only: [:show, :edit, :update, :destroy]

  # GET /ml_notations
  # GET /ml_notations.json
  def index
    @ml_notations = MlNotation.all
  end

  # GET /ml_notations/1
  # GET /ml_notations/1.json
  def show
  end

  # GET /ml_notations/new
  def new
    @ml_notation = MlNotation.new
  end

  # GET /ml_notations/1/edit
  def edit
  end
   

  # POST /ml_notations
  # POST /ml_notations.json
  def create
    @ml_notation = MlNotation.new(ml_notation_params)

    respond_to do |format|
      if @ml_notation.save
        format.html { redirect_to @ml_notation, notice: 'Ml notation was successfully created.' }
        format.json { render :show, status: :created, location: @ml_notation }
      else
        format.html { render :new }
        format.json { render json: @ml_notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ml_notations/1
  # PATCH/PUT /ml_notations/1.json
  def update
    respond_to do |format|
      if @ml_notation.update(ml_notation_params)
        format.html { redirect_to @ml_notation, notice: 'Ml notation was successfully updated.' }
        format.json { render :show, status: :ok, location: @ml_notation }
      else
        format.html { render :edit }
        format.json { render json: @ml_notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ml_notations/1
  # DELETE /ml_notations/1.json
  def destroy
    @ml_notation.destroy
    respond_to do |format|
      format.html { redirect_to ml_notations_url, notice: 'Ml notation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_notation
      @ml_notation = MlNotation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ml_notation_params
      params.require(:ml_notation).permit(:entry_id, :attr_value_id, :observation_id, :certain)
    end
end
