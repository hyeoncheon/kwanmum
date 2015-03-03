require 'test_helper'

class LogsControllerTest < ActionController::TestCase
  setup do
    @log = logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create log" do
    assert_difference('Log.count') do
      post :create, log: { action: @log.action, actor: @log.actor, category: @log.category, client_id: @log.client_id, client_type: @log.client_type, hostname: @log.hostname, level: @log.level, message: @log.message, process: @log.process, reason: @log.reason, service: @log.service, tag: @log.tag, target: @log.target, time: @log.time }
    end

    assert_redirected_to log_path(assigns(:log))
  end

  test "should show log" do
    get :show, id: @log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @log
    assert_response :success
  end

  test "should update log" do
    patch :update, id: @log, log: { action: @log.action, actor: @log.actor, category: @log.category, client_id: @log.client_id, client_type: @log.client_type, hostname: @log.hostname, level: @log.level, message: @log.message, process: @log.process, reason: @log.reason, service: @log.service, tag: @log.tag, target: @log.target, time: @log.time }
    assert_redirected_to log_path(assigns(:log))
  end

  test "should destroy log" do
    assert_difference('Log.count', -1) do
      delete :destroy, id: @log
    end

    assert_redirected_to logs_path
  end
end
