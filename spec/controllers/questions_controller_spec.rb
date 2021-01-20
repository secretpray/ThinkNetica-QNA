require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:roque) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }


    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end


    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), user_id: user }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'An attempt to update a question by a non-author of the question' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, user_id: roque } }

      it 'does not change question' do
        expect(question.title).not_to eq 'new title'
        expect(question.title).to eq 'MyString'
        expect(question.body).not_to eq 'new body'
        expect(question.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question, user: user) }
    let!(:other_author_question) { create(:question, user: roque ) }

    context 'Authenticated user ' do
      it 'delete his question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        expect(flash[:notice]).to match "Question deleted successfully"
      end

      it 'and redirects to index' do
        delete :destroy, params: { id: question, user_id: user }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Authenticated user ' do
      it "can`t delete someone else's question" do
        expect { delete :destroy, params: { id: other_author_question.id } }.to_not change(Question, :count)
        expect(flash[:notice]).to_not match "Question deleted successfully"
      end
    end
  end
end
