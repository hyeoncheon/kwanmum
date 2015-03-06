class LogsController < ApplicationController
  before_action :set_log, only: [:show, :update, :dismiss]

  # GET /logs
  # GET /logs.json
  def index
    if params[:server_id]
      @logs = Server.find(params[:server_id]).logs
    elsif params[:user_id]
      @logs = User.find(params[:user_id]).logs
    else
      @logs = Log.all
    end
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # PUT /logs/1/dismiss
  def dismiss
    @log.toggle!(:dismissed)
    redirect_to env['HTTP_REFERER'], notice: 'Dismissed'
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { render :show, status: :ok, location: @log }
      else
        format.html { render :edit }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
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
