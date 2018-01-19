require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  let!(:user) { create(:user) }
  let(:headers) { {
    'Accept'=>'application.vnd.taskmanager.v2',
    'Content-Type' => Mime[:json].to_s
  } }
  before do
    host! 'api.test.local'
  end

  describe 'POST /v2/sessions' do
    before do
      post '/v2/sessions', params: {session: credentials}.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { {email: user.email, password: user.password} }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns the json data for the user with a new auth token' do
        old_token = user.auth_token
        user.reload
        expect(json_body[:data][:attributes][:'auth-token']).to eq(user.auth_token)
        expect(json_body[:data][:attributes][:'auth-token']).not_to eq(old_token)
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

  describe 'DELETE /sessions/:id' do
    let(:auth_token) { user.auth_token }
    before do
      delete "/v2/sessions/#{auth_token}", headers: headers
    end

    it "retutns status code 204" do
      expect(response).to have_http_status(204)
    end

    it 'changes the user auth token' do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end

  end
end