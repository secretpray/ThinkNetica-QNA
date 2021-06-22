
require 'rails_helper'

shared_examples "commented" do

  describe 'POST create_comment' do
    context 'authenticated user', authenticated: true do
      it 'create valid comment' do
        login(user)

        commentable = described_class.controller_name.classify.underscore == 'question' ? question : answer
        expect { post :create_comment, params: { id: commentable, comment: { body: 'comment body' }, format: :js } }.to change(Comment, :count).by 1
        expect(assigns(:commentable) ).to eq commentable
      end

      it 'change comments count in commentable' do
        login(user)
        commentable = described_class.controller_name.classify.underscore == 'question' ? question : answer
        expect { post :create_comment, params: { id: commentable, comment: { body: 'comment body' }, format: :js } }.to change{commentable.reload.comments.count}.from(0).to(1)
      end

      it 'adds new comment to user' do
        login(user)
        commentable = described_class.controller_name.classify.underscore == 'question' ? question : answer
        expect { post :create_comment, params: { id: commentable, comment: { body: 'comment body' }, format: :js } }.to change{user.reload.comments.size}.from(0).to(1)
      end

      it 'renders comment template' do
        login(user)
        commentable = described_class.controller_name.classify.underscore == 'question' ? question : answer
        post :create_comment, params: { id: commentable, comment: { body: 'comment body' }, format: :js }
        expect(response).to render_template 'shared/create_comment'
      end

      it 'delete own comment' do
        login(user)

        resource_id = "#{described_class.controller_name.downcase}_id".to_sym
        commentable = described_class.controller_name.classify.underscore == 'question' ? question : answer
        post "create_comment", params:{ id: commentable.id, comment: { body: 'comment body' }, format: :js }
        expect {delete 'delete_comment', params: { id: Comment.last.id}, format: :js }.to change(Comment, :count).by(-1)
        expect(assigns(:commentable) ).to eq commentable
      end
    end
  end
end
