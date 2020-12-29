# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength

class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  after_action :verify_authorized, except: [:index, :enter, :inference]
  # GET /datasets
  # GET /datasets.json
  def index
    @datasets = Dataset.participant(current_user.id)
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
    render layout: "dataset"
  end

  def share_link
    @dataset = Dataset.find(params["dataset_id"])
    authorize @dataset, :update?
    if @dataset.share_link
      @dataset.share_link = nil
    else
      @dataset.share_link = SecureRandom.hex 8
    end
    @dataset.save
    redirect_to proc { dataset_members_url(@dataset) }
  end

  def inference
    @dataset= Dataset.find(params["dataset_id"])
    @observations = Observation.where(:dataset_id => params["dataset_id"])
    #authorize @dataset, :update?
    render layout: "dataset"
  end


  def enter
    @dataset = Dataset.where(:share_link => params["id"]).first
    unless @dataset.roles.pluck(:user_id).include?(current_user.id)
      @dataset.roles.new([{user_id: current_user.id, role: 1}])
      @dataset.save
    end
    redirect_to @dataset
  end

  def download
    @dataset = Dataset.find(params[:dataset_id])
    authorize @dataset, :update?
    render layout: "dataset"
  end

  def generate
    @dataset = Dataset.find(params[:dataset_id])
    authorize @dataset, :update?
    entries = Entry.where(:dataset_id => params[:dataset_id])
    classes = Observation.where(:dataset_id => params[:dataset_id])
    notations = Notation.where(:dataset_id => params[:dataset_id])
    headers = ['texto'] + classes.pluck(:name)
    confi = params[:confidence].empty? ? 0 : Integer(params[:confidence]) 
    csv = CSV.generate(headers: true) do |csv|
      csv << headers
      entries.each do |e|
        line = []
        line << e.text
        classes.each do |c|
          count = c.notations.where(:entry => e).pluck('notations.attr_value_id').tally.sort_by{|k,v| v}.reverse
          if count.size >= 2 
            if count[0][1] != count[1][1]
              if count[0][1] >= confi
                max_id = count[0][0]
              end
              logger.debug(max_id)
              text = "-1"
            else
              max_id = nil
              text = "Empate"
            end
          else
            if count.size > 0
              if count[0][1] >= confi
                max_id = count[0][0]
              end
              logger.debug(max_id)
              text = "-1"
            else
              max_id = nil
              text = "0"
            end
          end
          if max_id
            text = AttrValue.find(max_id).value
          end
          line << text
        end
        csv << line
      end
    end
    send_data csv, :disposition => "attachment; filename=dataset.csv", :type => 'text/csv; charset=iso-8859-1; header=present'
  end

  # GET /datasets/new
  def new
    @dataset = Dataset.new
    authorize @dataset
  end

  # GET /datasets/1/edit
  def edit
    render layout: "dataset"
  end

  # POST /datasets
  # POST /datasets.json
  def create
    @dataset = Dataset.new(dataset_params)
    @dataset.roles.new([{ user_id: current_user.id, role: 0 }])
    authorize @dataset
    
    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully created.' }
        format.json { render :show, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end 
    end
  end

  # PATCH/PUT /datasets/1
  # PATCH/PUT /datasets/1.json
  def update
    respond_to do |format|
      if @dataset.update(dataset_params)
        format.html { redirect_to @dataset, notice: 'Dataset was successfully updated.' }
        format.json { render :show, status: :ok, location: @dataset }
      else
        format.html { render :edit }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    @dataset.destroy
    respond_to do |format|
      format.html { redirect_to datasets_url, notice: 'Dataset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
      authorize @dataset
    end

    # Only allow a list of trusted parameters through.
    def dataset_params
      params.require(:dataset).permit(:name, :description)
    end
end
