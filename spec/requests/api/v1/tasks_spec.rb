require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
	let!(:user) { create(:user) }
	let(:headers) { {
		'Accept'=>'application.vnd.taskmanager.v1',
		'Content-Type' => Mime[:json].to_s,
		'Authorization' => user.auth_token
	} }

	before do
		host! 'api.test.local'
	end

	describe 'GET /v1/tasks' do
		before do
			create_list(:task, 5, user: user)
			get '/v1/tasks', headers: headers
		end

		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end

		it 'returns 5 tasks from database' do
			expect(json_body[:tasks].count).to eq(5)
		end
	end

	describe 'GET /v1/tasks/:id' do
	let!(:task) { create(:task, user: user) }
	let(:task_id) { task.id }
		before do
			get "/v1/tasks/#{task_id}", headers: headers
		end

	  it 'returns status code 200' do
			expect(response).to have_http_status(200)
	  end

	  it 'returns data task' do
	  	expect(json_body[:id]).to eq(task.id)
	  	expect(json_body[:title]).to eq(task.title)
	  end
	end

end