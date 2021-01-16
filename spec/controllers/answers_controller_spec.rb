require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:roque) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:other_author_answer) { create(:answer, question: question, user: roque) }

  describe '#GET new' do
    before { login(user) }
    before { get :new, params: { question_id: question, user_id: user } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Answer to parent Question' do
      expect(assigns(:answer).question).to eq(question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { question_id: question, id: answer, user_id: user } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user } }.to change(question.answers, :count).by(1)
      end

      it 'created Answer belongs to current user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(assigns(:answer).user).to eq user
      end

      it 'saves new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user } }.to_not change(Answer, :count)
      end


      it 're-renders question view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    before { patch :update, params: { question_id: question, id: answer, user_id: user, answer: attributes_for(:answer) } }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, user_id: user, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { user_id: user, question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { user_id: user, question_id: question, id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'Authenticated user ' do
      before { patch :update, params: { question_id: question, id: other_author_answer, answer: { body: 'new body' } } }

      it "can`t update someone else's answer" do
        answer.reload

        expect(answer.body).to_not eq 'new body'
        expect(flash[:alert]).to match 'You are not authorized to perform this operation.'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:user) { create(:user) }
    let!(:roque) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_author_answer) { create(:answer, question: question, user: roque) }

    context 'Authenticated user ' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
        expect{answer.reload}.to raise_error(ActiveRecord::RecordNotFound)
        expect(flash[:notice]).to match "Answer deleted successfully"
        expect(flash[:alert]).to_not match 'You are not authorized to perform this operation.'
      end

      it 'redirects to index' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Authenticated user ' do
      it "can`t delete someone else's answer" do
        expect { delete :destroy, params: { question_id: question, id: other_author_answer } }.to_not change(Answer, :count)
        expect(flash[:notice]).to_not match "Answer deleted successfully"
        expect(flash[:alert]).to match 'You are not authorized to perform this operation.'
      end
    end
  end
end
