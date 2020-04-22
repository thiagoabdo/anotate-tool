class AttrValuesController < ApplicationController
  before_action :set_attr_value, only: [:show, :edit, :update, :destroy]

  # GET /attr_values
  # GET /attr_values.json
  def index
    @attr_values = AttrValue.all
  end

  # GET /attr_values/1
  # GET /attr_values/1.json
  def show
  end

  # GET /attr_values/new
  def new
    @attr_value = AttrValue.new
    @observations = Observation.from_user_naousar(current_user)
  end

  # GET /attr_values/1/edit
  def edit
  end

  # POST /attr_values
  # POST /attr_values.json
  def create
    @attr_value = AttrValue.new(attr_value_params)

    respond_to do |format|
      if @attr_value.save
        format.html { redirect_to @attr_value, notice: 'Attr value was successfully created.' }
        format.json { render :show, status: :created, location: @attr_value }
      else
        format.html { render :new }
        format.json { render json: @attr_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attr_values/1
  # PATCH/PUT /attr_values/1.json
  def update
    respond_to do |format|
      if @attr_value.update(attr_value_params)
        format.html { redirect_to @attr_value, notice: 'Attr value was successfully updated.' }
        format.json { render :show, status: :ok, location: @attr_value }
      else
        format.html { render :edit }
        format.json { render json: @attr_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attr_values/1
  # DELETE /attr_values/1.json
  def destroy
    @attr_value.destroy
    respond_to do |format|
      format.html { redirect_to attr_values_url, notice: 'Attr value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attr_value
      @attr_value = AttrValue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attr_value_params
      params.require(:attr_value).permit(:value, :observation_id)
    end
end
