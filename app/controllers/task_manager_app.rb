require 'yaml/store'

class TaskManagerApp < Sinatra::Base
  get '/' do
    erb :dashboard
  end

  get "/tasks" do
    if params[:title]
      task_manager.find_by(tilte: params[:title])
    else
      @tasks = task_manager.all
    end
    erb :index
  end

  get "/tasks/new" do
    erb :new
  end

  post "/tasks" do
    task_manager.create(params[:task])
    redirect '/tasks'
  end

  get "/tasks/:id" do |id|
    @task = task_manager.find(id)
    erb :show
  end

  get "/tasks/:id/edit" do |id|
    @task = task_manager.find(id.to_i)
    erb :edit
  end

  put "/tasks/:id" do |id|
    task_manager.update(params[:task], id.to_i)
    redirect "/tasks/#{id}"
  end

  delete "/tasks/:id" do |id|
    task_manager.delete(id.to_i)
    redirect "/tasks"
  end

  not_found do
    erb :error 
  end

  def task_manager
    if ENV["RACK_ENV"] == "test"
      database = Sequel.sqlite("db/task_manager_test.sqlite3")
    else
      database = Sequel.sqlite("db/task_manager_development.sqlite3")
    end
    @task_manager ||= TaskManager.new(database)
  end
end
