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

	describe 'POST /v1/tasks' do
	  before do
	  	post '/v1/tasks', params: {task: task_params}.to_json, headers: headers
	  end
	  context 'when the params are valid' do
			let(:task_params) { attributes_for(:task) }
	  	it 'returns status code 201' do
	  		expect(response).to have_http_status(201)
	  	end
	  	it 'saves the task in database' do
	  		expect( Task.find_by(id: json_body[:id]) ).not_to be_nil
	  	end
	  	it 'returns the json for created task' do
	  		expect(json_body[:title]).to eq(task_params[:title])

	  	end
	  	it 'assigns the created task to the current user' do
	  		expect(json_body[:user_id]).to eq(user.id)
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

end