require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let!(:user) { create(:user) }
  let(:headers) { {
    'Accept'=>'application.vnd.taskmanager.v1',
    'Content-Type' => Mime[:json].to_s
  } }
  before do
    host! 'api.test.local'
  end

  describe 'POST /v1/sessions' do
    before do
      post '/v1/sessions', params: {session: credentials}.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { {email: user.email, password: user.password} }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the json data for the user with a new auth token' do
        old_token = user.auth_token
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
        expect(json_body[:auth_token]).not_to eq(old_token)
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { {email: user.email, password: 'invalid_pwd'} }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end