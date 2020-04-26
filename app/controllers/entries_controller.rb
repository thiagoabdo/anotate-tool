class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  after_action :verify_authorized, except: [ :index, :new, :gupload ]


  def gupload
    @dataset = Dataset.find(id=params["dataset_id"])
    render layout: "dataset"
  end

  def upload
    @dataset = Dataset.find(id=params["dataset_id"])
    authorize @dataset
    # uploaded_io = params[:csv_entries]
    # File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #   file.write(uploaded_io.read)
    # end
    Entry.import(params[:csv_entries], params["dataset_id"])
    respond_to do |format|
      format.html { redirect_to dataset_entries_url(@dataset), notice: 'Database was reseted.' }
      format.json { head :no_content }
    end
  end

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.where(dataset_id: params["dataset_id"])
    @dataset = Dataset.find(id=params["dataset_id"])
    render layout: "dataset"
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
    @dataset = Dataset.find(id=params["dataset_id"])
    render layout: "dataset"
  end

  # GET /entries/1/edit
  def edit
    @dataset = @entry.dataset
  end

  # POST /entries
  # POST /entries.json
  def create  
    @entry = Entry.new(entry_params)
    @dataset = @entry.dataset
    authorize @entry

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @dataset, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      @dataset = @entry.dataset
      if @entry.update(entry_params)
        format.html { redirect_to dataset_entries_url(@dataset), notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @dataset = @entry.dataset
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to dataset_entries_url(@dataset), notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    @dataset = Dataset.find(params["dataset_id"])
    authorize @dataset
    Entry.where(:dataset_id => params["dataset_id"]).destroy_all
    respond_to do |format|
      format.html { redirect_to dataset_entries_url(@dataset), notice: 'Database was reseted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
      authorize @entry
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:text, :dataset_id)
    end
end
