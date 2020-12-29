class MlFeaturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:pupdate]
  before_action :set_ml_feature, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :kfold, :needfeatures, :getall, :pupdate]
  # TODO: add authorization to getall and pupdate
  # TODO add constrain of uniqness to entry_id



  # GET /ml_features
  # GET /ml_features.json
  def index
    @ml_features = MlFeature.all
  end

  # GET /ml_features/1
  # GET /ml_features/1.json
  def show
  end

  # GET /ml_features/new
  def new
    @ml_feature = MlFeature.new
  end

  # GET /ml_features/1/edit
  def edit
  end

  def getall
    @dataset = params[:dataset_id]
    @ml_feature = Entry.where(dataset: @dataset).includes(:ml_feature).references(:ml_feature)

    respond_to do |format|
      format.json { render json: @ml_feature, include: [:ml_feature]}
    end
  end

  def needfeatures
    @dataset = params[:dataset_id]
    @ml_feature = Entry.where(dataset: @dataset).left_outer_joins(:ml_feature).where('ml_features.id': nil).first

    @need = @ml_feature ? true : false
    respond_to do |format|
      format.json { render json: @need }
    end
  end
  
  # POST /ml_features
  # POST /ml_features.json
  def create
    @ml_feature = MlFeature.new(ml_feature_params)

    respond_to do |format|
      if @ml_feature.save
        format.html { redirect_to @ml_feature, notice: 'Ml feature was successfully created.' }
        format.json { render :show, status: :created, location: @ml_feature }
      else
        format.html { render :new }
        format.json { render json: @ml_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ml_features/1
  # PATCH/PUT /ml_features/1.json
  def update
    respond_to do |format|
      if @ml_feature.update(ml_feature_params)
        format.html { redirect_to @ml_feature, notice: 'Ml feature was successfully updated.' }
        format.json { render :show, status: :ok, location: @ml_feature }
      else
        format.html { render :edit }
        format.json { render json: @ml_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def pupdate
    attributes = {
      entry_id: params["id"],
      feature: params["feature"]
    }
    @ml_feature  = MlFeature.where(entry_id: params["id"]).first_or_initialize


    respond_to do |format|
      if @ml_feature.update(attributes)
        format.json { render json: @ml_feature }
      else
        format.html { render :edit }
      end
    end
  end


  # DELETE /ml_features/1
  # DELETE /ml_features/1.json
  def destroy
    @ml_feature.destroy
    respond_to do |format|
      format.html { redirect_to ml_features_url, notice: 'Ml feature was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_feature
      @ml_feature = MlFeature.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ml_feature_params
      params.require(:ml_feature).permit(:belongs_to, :string)
    end
end
