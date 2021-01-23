require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'test-file.txt') }

  before { login(user) }

  describe 'DELETE #destroy' do
    it 'assigns the requested attachment to @attachment' do
      delete :destroy, params: { id: question.files.first }, format: :js

      expect(assigns(:attachment)).to eq question.files.first
    end

    describe 'question' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'test-file.txt')
      end

      context 'Authenticated user an author of the question' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authenticated user not an author of the question' do
        before { login(another_user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.not_to change(question.files, :count)
        end
      end
    end

    describe 'answer' do
      let(:answer) { create(:answer, question: question, user: user) }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'test-file.txt')
      end

      context 'Authenticated user an author of the answer' do
        it 'deletes an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authenticated user not an author of the answer' do
        before { login(another_user) }

        it 'does not delete an attachment' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(answer.files, :count)
        end
      end
    end
  end
end
