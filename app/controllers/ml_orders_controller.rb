class MlOrdersController < ApplicationController
  before_action :set_ml_order, only: [:show, :edit, :update, :destroy]

  # GET /ml_orders
  # GET /ml_orders.json
  def index
    @ml_orders = MlOrder.all
  end

  # GET /ml_orders/1
  # GET /ml_orders/1.json
  def show
  end

  # GET /ml_orders/new
  def new
    @ml_order = MlOrder.new
  end

  # GET /ml_orders/1/edit
  def edit
  end

  # POST /ml_orders
  # POST /ml_orders.json
  def create
    @ml_order = MlOrder.new(ml_order_params)

    respond_to do |format|
      if @ml_order.save
        format.html { redirect_to @ml_order, notice: 'Ml order was successfully created.' }
        format.json { render :show, status: :created, location: @ml_order }
      else
        format.html { render :new }
        format.json { render json: @ml_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ml_orders/1
  # PATCH/PUT /ml_orders/1.json
  def update
    respond_to do |format|
      if @ml_order.update(ml_order_params)
        format.html { redirect_to @ml_order, notice: 'Ml order was successfully updated.' }
        format.json { render :show, status: :ok, location: @ml_order }
      else
        format.html { render :edit }
        format.json { render json: @ml_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ml_orders/1
  # DELETE /ml_orders/1.json
  def destroy
    @ml_order.destroy
    respond_to do |format|
      format.html { redirect_to ml_orders_url, notice: 'Ml order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_order
      @ml_order = MlOrder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ml_order_params
      params.require(:ml_order).permit(:entry_id, :observation_id, :order)
    end
end
