require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) { {
    'Accept'=>'application.vnd.taskmanager.v2',
    'Content-Type' => Mime[:json].to_s,
    'Authorization' => user.auth_token
  } }

  before do
    host! 'api.test.local'
  end

  describe 'GET /v2/users/:id' do
    before do
      get "/v2/users/#{user_id}", headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        expect(json_body[:id]).to equal(user_id)
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

  describe 'POST /v2/users' do
    before do
      post '/v2/users', params: {user: user_params}.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end
      it 'returns json data for the created user' do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end
    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid-mail') }
      it "return status code 422" do
        expect(response).to have_http_status(422)
      end
      it 'returns json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /v2/users/:id' do

    before do
      put "/v2/users/#{user_id}", params: {user: user_params}.to_json, headers: headers
    end

    context "when the request params are valid" do
      let(:user_params) { {email: 'new@email.com'} }
      it "return status code 200" do
        expect(response).to have_http_status(200)
      end
      it "return json data for the updated user" do
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end
    context "when the request params are invalid" do
      let(:user_params) { attributes_for(:user, email: 'invalidmail') }
      it "return status code 422" do
        expect(response).to have_http_status(422)
      end
      it 'returns json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /v2/users/:id' do

    before do
      delete "/v2/users/#{user_id}", headers: headers
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect( User.find_by(id: user_id) ).to be_nil
    end

  end
end