require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |field|
          expect(json['questions'].first[field]).to eq questions.first.send(field).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |field|
            expect(answer_response[field]).to eq answer.send(field).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_attached_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
    let!(:links) { create_list(:link, 3, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |field|
          expect(question_response[field]).to eq question.send(field).as_json
        end
      end

      it_behaves_like 'API Commentable' do
        let(:comment) { comments.first }
        let(:comments_response) { question_response['comments'] }
        let(:comment_response) { comments_response.first }
      end

      it_behaves_like 'API Linkable' do
        let(:link) { links.first }
        let(:links_response) { question_response['links'] }
        let(:link_response) { links_response.first }
      end

      it_behaves_like 'API Attacheble' do
        let(:file) { question.files.first }
        let(:files_response) { question_response['files'] }
        let(:file_response) { files_response.first }
        let(:files) { question.files }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'valid params' do
        it 'saves a new question in the database' do
          expect do
            post api_path, params: { question: attributes_for(:question, :with_link), access_token: access_token.token }
          end.to change(Question, :count).by(1)
        end

        it 'return status 201' do
          post api_path, params: { question: attributes_for(:question, :with_link), access_token: access_token.token }
          expect(response).to have_http_status(:created)
        end

        it 'not return errors' do
          post api_path, params: { question: attributes_for(:question, :with_link), access_token: access_token.token }
          expect(response.body).to be_empty
        end
      end

      context 'invalid params' do
        it 'does not save the question with invalid params' do
          expect do
            post api_path, params: { question: attributes_for(:question, :invalid) }
          end.to_not change(Question, :count)
        end

        it 'return status 422' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'return errors' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(json).to_not have_key(:errors)
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let!(:question) { create(:question, user: user) }
    let!(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      context 'as question owner' do
        let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'valid params' do
          before do
            put api_path, params: { id: question,
                                    question: { title: 'new title', body: 'new body' },
                                    access_token: access_token.token }
          end

          it 'changes question attributes' do
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'returns status 200' do
            expect(response).to be_successful
          end
        end

        context 'invalid params' do
          before do
            put api_path, params: { id: question,
                                    question: attributes_for(:question, :invalid),
                                    access_token: access_token.token }
          end

          it 'does not change attributes for question' do
            preview_state = question
            question.reload

            expect(question.title).to eq preview_state.title
            expect(question.body).to eq preview_state.body
          end

          it 'return status 422' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'return errors' do
            expect(json).to have_key('errors')
          end
        end
      end

      context 'as other user' do
        let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

        before do
          put api_path, params: { id: question,
                                  question: { title: 'new title', body: 'new body' },
                                  access_token: access_token.token }
        end

        it "doesn't change question attributes" do
          preview_state = question
          question.reload

          expect(question.title).to eq preview_state.title
          expect(question.body).to eq preview_state.body
        end

        it 'returns status 403' do
          expect(response).to have_http_status(:forbidden)
        end

        it 'has error' do
          expect(json['error']).to be
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let!(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'as question owner' do
        let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'valid params' do
          let!(:api_path) { "/api/v1/questions/#{question.id}" }

          it 'changes question attributes' do
            expect do
              delete api_path, params: { access_token: access_token.token }
            end.to change(Question, :count).by(-1)
          end

          it 'returns status 200' do
            delete api_path, params: { access_token: access_token.token }
            expect(response).to be_successful
          end
        end

        context 'invalid params' do
          let!(:api_path) { "/api/v1/questions/#{-1}" }

          it 'does not delete question' do
            expect do
              delete api_path, params: { access_token: access_token.token }
            end.to_not change(Question, :count)
          end

          it 'return status 404' do
            delete api_path, params: { access_token: access_token.token }
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'as other user' do
        let!(:api_path) { "/api/v1/questions/#{question.id}" }
        let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

        it "doesn't delete record" do
          expect do
            delete api_path, params: { access_token: access_token.token }
          end.to_not change(Question, :count)
        end

        it 'returns status 403' do
          delete api_path, params: { access_token: access_token.token }
          expect(response).to have_http_status(:forbidden)
        end

        it 'has error' do
          delete api_path, params: { access_token: access_token.token }
          expect(json['error']).to be
        end
      end
    end
  end
end
