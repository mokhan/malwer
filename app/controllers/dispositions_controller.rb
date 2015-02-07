class DispositionsController < ApplicationController
  before_action :set_disposition, only: [:show, :edit, :update, :destroy]

  # GET /dispositions
  # GET /dispositions.json
  def index
    @dispositions = Disposition.all
  end

  # GET /dispositions/1
  # GET /dispositions/1.json
  def show
  end

  # GET /dispositions/new
  def new
    @disposition = Disposition.new
    @states = Disposition.states
  end

  # GET /dispositions/1/edit
  def edit
    @states = Disposition.states
  end

  # POST /dispositions
  # POST /dispositions.json
  def create
    fingerprint = disposition_params[:fingerprint]
    Publisher.publish("commands.poke.#{fingerprint}", disposition_params)

    respond_to do |format|
      format.html { redirect_to dispositions_path, notice: 'Disposition was successfully created.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /dispositions/1
  # PATCH/PUT /dispositions/1.json
  def update
    Publisher.publish("poke", disposition_params)
    respond_to do |format|
      format.html { redirect_to dispositions_path, notice: 'Disposition was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # DELETE /dispositions/1
  # DELETE /dispositions/1.json
  def destroy
    @disposition.destroy
    respond_to do |format|
      format.html { redirect_to dispositions_url, notice: 'Disposition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disposition
      @disposition = Disposition.find_by(fingerprint: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disposition_params
      params.require(:disposition).permit(:fingerprint, :state)
    end
end
