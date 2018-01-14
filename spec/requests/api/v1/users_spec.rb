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
end