require 'rails_helper'

describe SearchesController, type: :controller, aggregate_failures: true do

  describe 'GET #index' do
    context 'with valid attributes' do
      context 'question' do
        let!(:questions) { create_list(:question, 4) }

        before do
          expect(SearchService).to receive(:call).and_return(questions)
          get :index, params: { query: questions.first.title, type: 'Question' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign SearchService.call to @result" do
          expect(assigns(:result)).to eq questions
        end
      end

      context 'answer' do
        let!(:answers) { create_list(:answer, 4) }

        before do
          expect(SearchService).to receive(:call).and_return(answers)
          get :index, params: { query: answers.first.body, type: 'Answer' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq answers
        end
      end

      context 'comment' do
        let!(:comments) { create_list(:comment, 4, commentable: create(:question)) }

        before do
          expect(SearchService).to receive(:call).and_return(comments)
          get :index, params: { query: comments.first.body, type: 'Comment' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq comments
        end
      end

      context 'user' do
        let!(:users) { create_list(:user, 4) }

        before do
          expect(SearchService).to receive(:call).and_return(users)
          get :index, params: { query: users.first.email, type: 'User' }
        end

        it "renders index view" do
          expect(response).to render_template :index
        end

        it "200" do
          expect(response).to be_successful
        end

        it "assign Search.call to @result" do
          expect(assigns(:result)).to eq users
        end
      end
    end
  end
end
