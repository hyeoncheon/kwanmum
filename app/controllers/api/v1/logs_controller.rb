class Api::V1::LogsController < Api::ApiController
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs.json
  def index
    @logs = Log.all
  end

  # GET /logs/1.json
  def show
  end

  # POST /logs.json
  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.json { render :show, status: :created, location: @log }
      else
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.json { render :show, status: :ok, location: @log }
      else
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_log
      @log = Log.find(params[:id])
    end

    def log_params
      params.require(:log).permit(:category, :level, :time, :service, :hostname, :process, :message, :actor, :action, :target, :reason, :tag, :client_id, :client_type)
    end
end
# vim: set ts=2 sw=2 expandtab:
