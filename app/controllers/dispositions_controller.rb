class DispositionsController < ApplicationController
  before_action :set_disposition, only: [:show, :edit, :update, :destroy]

  def index
    @dispositions = Disposition.all
  end

  def show
  end

  def new
    @disposition = Disposition.new
    @states = Disposition.states
  end

  def edit
    @states = Disposition.states
  end

  def create
    fingerprint = disposition_params[:fingerprint]
    Publisher.publish("commands.poke.#{fingerprint}", disposition_params)

    redirect_to dispositions_path, notice: 'Disposition was successfully created.'
  end

  def update
    Publisher.publish("poke", disposition_params)
    redirect_to dispositions_path, notice: 'Disposition was successfully updated.'
  end

  def destroy
    @disposition.destroy
    redirect_to dispositions_url, notice: 'Disposition was successfully destroyed.'
  end

  private

  def set_disposition
    @disposition = Disposition.find_by(fingerprint: params[:id])
  end

  def disposition_params
    params.require(:disposition).permit(:fingerprint, :state)
  end
end
