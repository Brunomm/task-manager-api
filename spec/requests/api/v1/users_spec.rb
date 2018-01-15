require 'rails_helper'

RSpec.describe 'Users API', type: :request do
	let!(:user) { create(:user) }
	let(:user_id) { user.id }
	let(:headers) { {'Accept'=>'application.vnd.taskmanager.v1'} }

	before do
		host! 'api.test.local'
	end

	describe 'GET /v1/users/:id' do
		before do
			get "/v1/users/#{user_id}", headers: headers
		end

		context 'when the user exists' do
			it 'returns the user' do
				user_response = JSON.parse(response.body)
				expect(user_response['id']).to equal(user_id)
			end

			it 'returns status 200' do
				expect(response).to have_http_status(200)
			end
		end

		context 'when the user not exists' do
			let(:user_id) { User.maximum(:id).to_i + 1 }
			it 'returns status 404' do
				expect(response).to have_http_status(404)
			end
		end
	end

	describe 'POST /v1/users' do
		before do
			post '/v1/users', params: {user: user_params}
		end

		context 'when the request params are valid' do
			let(:user_params) { attributes_for(:user) }
			it 'return status code 201' do
				expect(response).to have_http_status(201)
			end
			it 'returns json data for the created user' do
				user_response = JSON.parse(response.body)
				expect(user_response['email']).to eq(user_params[:email])
			end
		end
		context 'when the request params are invalid' do
			let(:user_params) { attributes_for(:user, email: 'invalid-mail') }
			it "return status code 422" do
				expect(response).to have_http_status(422)
			end
			it 'returns json data for the errors' do
				user_response = JSON.parse(response.body)
				expect(user_response).to have_key('errors')
			end
		end
	end
end