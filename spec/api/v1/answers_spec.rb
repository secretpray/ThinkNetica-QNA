require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) {{ "ACCEPT" => 'application/json' }}

  describe 'GET /api/v1/questions/:id/answers' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let!(:answer) { answers.first }
    let!(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |field|
          expect(json['answers'].first[field]).to eq answer.send(field).as_json
        end
      end

      it 'does not return private fields' do
        expect(json).to_not have_key('question_id')
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer, :with_attached_files, question: question) }
    let!(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
    let!(:links) { create_list(:link, 3, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |field|
          expect(json['answer'][field]).to eq answer.send(field).as_json
        end
      end

      describe 'question' do
        let!(:answer_response) { json['answer'] }

        it 'returns question' do
          expect(answer_response['question']).to be
        end

        it 'returns all public fields' do
          %w[id title body created_at updated_at].each do |field|
            expect(answer_response['question'][field]).to eq question.send(field).as_json
          end
        end
      end

      # it_behaves_like 'API Commentable' do
      #   let(:comment) { comments.first }
      #   let(:comments_response) { json['answer']['comments'] }
      #   let(:comment_response) { comments_response.first }
      # end
      #
      # it_behaves_like 'API Linkable' do
      #   let(:link) { links.first }
      #   let(:links_response) { json['answer']['links'] }
      #   let(:link_response) { links_response.first }
      # end
      #
      # it_behaves_like 'API Attacheble' do
      #   let(:file) { answer.files.first }
      #   let(:files_response) { json['answer']['files'] }
      #   let(:file_response) { files_response.first }
      #   let(:files) { answer.files }
      # end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'valid params' do
        it 'saves an answer to the answer in the database' do
          expect do
            post api_path, params: { answer: attributes_for(:answer, :with_link, question: question), access_token: access_token.token }
          end.to change(Answer, :count).by(1)
        end

        it 'return status 201' do
          post api_path, params: { answer: attributes_for(:answer, :with_link, question: question), access_token: access_token.token }
          expect(response).to have_http_status(:created)
        end

        it 'not return errors' do
          post api_path, params: { answer: attributes_for(:answer, :with_link, question: question), access_token: access_token.token }
          expect(response.body).to be_empty
        end
      end

      context 'invalid params' do
        it 'does not save the answer with invalid params' do
          expect do
            post api_path, params: { answer: attributes_for(:answer, :invalid) }
          end.to_not change(Answer, :count)
        end

        it 'return status 422' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'return errors' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(json).to_not have_key(:errors)
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let!(:answer) { create(:answer, question: create(:question, user: user), user: user) }
    let!(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      context 'as answer owner' do
        let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'valid params' do
          before do
            put api_path, params: { #id: answer,
                                    answer: { body: 'new body' },
                                    access_token: access_token.token }
          end

          it 'changes answer attributes' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end

          it 'returns status 200' do
            expect(response).to be_successful
          end
        end

        context 'invalid params' do
          before do
            put api_path, params: { answer: attributes_for(:answer, :invalid),
                                    access_token: access_token.token }
          end

          it 'does not change attributes for question' do
            preview_state = answer
            answer.reload

            expect(answer.body).to eq preview_state.body
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
          put api_path, params: { answer: { body: 'new body' },
                                  access_token: access_token.token }
        end

        it "doesn't change answer attributes" do
          preview_state = answer
          answer.reload

          expect(answer.body).to eq preview_state.body
        end

        it 'returns status 403' do
          expect(response).to have_http_status(:forbidden)
        end

        it 'has error' do
          expect(json).to have_key('error')
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user) { create(:user, confirmed_at: DateTime.now) }
    let!(:answer) { create(:answer, question: create(:question, user: user), user: user) }

    it_behaves_like 'API Authorizable' do
      let!(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'as answer owner' do
        let!(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'valid params' do
          let!(:api_path) { "/api/v1/answers/#{answer.id}" }

          it 'changes answer attributes' do
            expect do
              delete api_path, params: { access_token: access_token.token }
            end.to change(Answer, :count).by(-1)
          end

          it 'returns status 200' do
            delete api_path, params: { access_token: access_token.token }
            expect(response).to be_successful
          end
        end

        context 'invalid params' do
          let!(:api_path) { "/api/v1/answers/#{-1}" }

          it 'does not delete answer' do
            expect do
              delete api_path, params: { access_token: access_token.token }
            end.to_not change(Answer, :count)
          end

          it 'return status 404' do
            delete api_path, params: { access_token: access_token.token }
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'as other user' do
        let!(:api_path) { "/api/v1/answers/#{answer.id}" }
        let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

        it "doesn't delete record" do
          expect do
            delete api_path, params: { access_token: access_token.token }
          end.to_not change(Answer, :count)
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
