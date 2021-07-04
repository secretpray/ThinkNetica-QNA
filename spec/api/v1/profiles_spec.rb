require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {{ "CONTENT_TYPE" => 'application/json',
                   "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/profiles/me' do

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 20x status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email role created_at updated_at].each do |field|
          expect(json['user'][field]).to eq me.send(field).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |field|
          expect(json['user']).to_not have_key(field)
        end
      end
    end
  end

  describe 'other' do
    let(:api_path) { '/api/v1/profiles/other' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 4, :admin) }
      let(:current_user) {users.last}
      let(:access_token) { create(:access_token, resource_owner_id: current_user.id) }

      before do
        get '/api/v1/profiles/other', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end


      it 'return all public fields' do
        %w[id email role created_at updated_at].each do |field|
          expect(json['users'].first[field]).to eq users.first.send(field).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |field|
          expect(json['users'].first).to_not have_key(field)
        end
      end

      it 'does not return current user' do
        json['users'].each do |user_json|
          expect(user_json['id']).to_not eq current_user.id
        end
      end
    end
  end
end
