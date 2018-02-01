require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let!(:user) { create(:user) }
  let(:headers) { {
    'Accept'=>'application.vnd.taskmanager.v2',
    'Content-Type' => Mime[:json].to_s,
    'Authorization' => user.auth_token
  } }

  before do
    host! 'api.test.local'
  end

  describe 'GET /v2/tasks' do
    context 'when no filter param is sent' do
      before do
        create_list(:task, 5, user: user)
        get '/v2/tasks', headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 5 tasks from database' do
        expect(json_body[:data].size).to eq(5)
      end
    end

    context 'when filter and sort params is sent' do
      let!(:notebook_task_1) { create(:task, user: user, title: 'Check if the notebook is broken') }
      let!(:notebook_task_2) { create(:task, user: user, title: 'Buy a new notebook ') }
      let!(:other_task_1) { create(:task, user: user, title: 'Fix the door ') }
      let!(:other_task_2) { create(:task, user: user, title: 'Buy a new car ') }

      before do
        get '/v2/tasks/', params: {q: {title_cont: 'teboo', s: 'title ASC'} }, headers: headers
      end

      it 'returns only the tasks matching' do
        task_titles = json_body[:data].map{|d| d[:attributes][:title]}
        expect(task_titles.size).to eq 2
        expect(task_titles).to include(notebook_task_1.title)
        expect(task_titles).to include(notebook_task_2.title)
      end

      it 'order tasks correcly' do
        expect( json_body[:data][0][:id] ).to eq( notebook_task_2.id.to_s )
        expect( json_body[:data][1][:id] ).to eq( notebook_task_1.id.to_s )
      end

    end
  end

  describe 'GET /v2/tasks/:id' do
    let!(:task) { create(:task, user: user) }
    let(:task_id) { task.id }
    before do
      get "/v2/tasks/#{task_id}", headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns data task' do
      expect(json_body[:data][:id]).to eq(task.id.to_s)
      expect(json_body[:data][:attributes][:title]).to eq(task.title)
    end
  end

  describe 'POST /v2/tasks' do
    before do
      post '/v2/tasks', params: {task: task_params}.to_json, headers: headers
    end
    context 'when the params are valid' do
      let(:task_params) { attributes_for(:task) }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'saves the task in database' do
        expect( Task.find_by(id: json_body[:data][:id]) ).not_to be_nil
      end
      it 'returns the json for created task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])

      end
      it 'assigns the created task to the current user' do
        expect(json_body[:data][:attributes][:'user-id']).to eq(user.id)
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { attributes_for(:task, title: nil) }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it "does not save the task in the database" do
        expect(Task.count).to eq(0)
      end
      it 'returns the json error for title' do
        expect(json_body[:errors][:title]).not_to be_nil
      end
    end
  end

  describe 'PUT /v2/tasks/:id' do
    let!(:task){ create(:task, user: user) }
    before do
      put "/v2/tasks/#{task.id}",  params: {task: task_params}.to_json, headers: headers
    end
    context 'when the params are valid' do
      let(:task_params) { {title: 'The new title'} }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns json for  updated task' do
        expect(json_body[:data][:attributes][:title]).to eq(task_params[:title])
      end
      it 'updates the task in the database' do
        expect(Task.find_by(id: task.id).title).to eq(task_params[:title])
      end
    end
    context 'when the params are invalid' do
      let(:task_params) { {title: ' '} }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns the json with the errors' do
        expect(json_body[:errors]).to have_key(:title)
      end
      it "does not update database" do
        expect(Task.find_by(title: '')).to be_nil
      end
    end
  end

  describe 'DELETE /v2/tasks/:id' do
    let!(:task){ create(:task, user: user) }
    before do
      delete "/v2/tasks/#{task.id}", headers: headers
    end
    it 'returns status code 204' do
        expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
      expect{ Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end