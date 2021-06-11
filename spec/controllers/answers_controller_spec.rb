require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "commented"

  let(:user) { create(:user) }
  let(:roque) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:other_author_answer) { create(:answer, question: question, user: roque) }

  it_behaves_like 'voted' do
    let(:model) { create :answer, user: user }
  end

  describe '#GET new' do
    before { login(user) }
    before { get :new, params: { question_id: question, user_id: user }, format: :js }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new Answer to parent Question' do
      expect(assigns(:answer).question).to eq(question)
    end

    it 'renders new view' do
      expect(response).to_not render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { question_id: question, format: :js, id: answer, user_id: user } }

  end

  describe 'POST #create' do
    before { login(user) }

    let(:valid_params) { { question_id: question.id, format: :js, answer: attributes_for(:answer) } }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'created Answer belongs to current user' do
        post :create, params: valid_params

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
    before {login(user)}

    context "updates own answer with valid attributes" do
      let(:valid_params) {{ question_id: question, id: answer.id, answer: { body: 'New Body' }, format: :js }}

      it "change attributes" do
        patch :update, params: valid_params
        answer.reload

        expect(answer.body).to eq "New Body"
      end

      it "renders template update" do
        patch :update, params: valid_params
        expect(response).to render_template 'answers/update'
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { user_id: user, question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template 'answers/update'
      end
    end

    context 'Authenticated user ' do
      before { patch :update, params: { question_id: question, id: other_author_answer, answer: { body: 'new body' } } }

      it "can`t update someone else's answer" do
        answer.reload

        expect(answer.body).to_not eq 'new body'
        expect(flash[:alert]).to match 'You are not authorized to perform this action.'
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
    let(:valid_params) { { question_id: question, id: answer, format: :js } }

    context 'Authenticated user ' do
      it 'deletes the answer' do
        expect { delete :destroy, params: valid_params }.to change(Answer, :count).by(-1)
        expect{answer.reload}.to raise_error(ActiveRecord::RecordNotFound)
        expect(flash[:alert]).to_not match 'You are not authorized to perform this action.'
      end

      it 'not redirects to index', js: true do
        delete :destroy, params: { question_id: question, id: answer, format: :js }
        expect(response).to_not redirect_to question_path(question)
      end
    end

    context 'Authenticated user ' do
      it "can`t delete someone else's answer" do
        expect { delete :destroy, params: { question_id: question, id: other_author_answer } }.to_not change(Answer, :count)
        expect(flash[:notice]).to_not match "Answer deleted successfully"
        expect(flash[:alert]).to match 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'PATCH #best' do

    let!(:another_question) { create(:question, user: roque) }
    let!(:another_answer) { create(:answer, question: another_question, user: roque) }

    before { login(user) }

    it 'assigns answer to @answer' do
      patch :best, params: { question_id: question, id: answer }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    context 'Authenticated user author of the question' do
      it 'selects the best question' do
        patch :best, params: { question_id: question, id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it "it assigns reward to user" do
        reward = create(:reward, question: question)
        patch :best, params: { question_id: question, id: answer }, format: :js
        answer.reload

        expect { reward.reload }.to change(reward, :user).from(nil).to(answer.user)
      end

    end

    context 'Not author of the question' do
      before { patch :best, params: { question_id: question, id: another_answer }, format: :js}

      it "unable to select best answer" do
        expect(another_answer.best).to be false
      end

      it "gets a forbidden flash message" do
        expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
      end
    end
  end
end
