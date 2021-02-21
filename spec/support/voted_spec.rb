require 'rails_helper'

shared_examples_for 'voted' do
  # let(:model) { described_class.name.gsub("Controller", "").singularize.constantize }
  # let(:votable) { create(model.to_s.underscore.to_sym) }
  # let(:user_votable) { create(model.to_s.underscore.to_sym, user: user) }

  let(:user) { create :user }
  let(:another_user) { create :user }

  describe 'PATCH #upvote' do
    it 'sends json response' do
      login(another_user)
      # binding.pry
      if model.is_a?(Answer)
        patch :upvote, params: { question_id: "#{model.question.id}", id: model.id}, format: :json
      else 
        patch :upvote, params: { id: model.id, format: :json }
      end

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can vote up' do
      login(another_user)

      expect do
        if model.is_a?(Answer)
          patch :upvote, params: { id: model.id, question_id: "#{model.question.id}" }, format: :json
        else 
          patch :upvote, params: { id: model.id }, format: :json
        end
      end.to change(Vote, :count).by 1
      expect(model.rating).to eq(1)
    end

    it "author's vote up for his own resource is not counted" do
      login(model.user)

      expect do
        if model.is_a?(Answer)
          patch :upvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
        else 
          patch :upvote, params: { id: model.id }, format: :json
        end
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end

  describe 'PATCH #downvote' do
    it 'sends json response' do
      login(another_user)
      if model.is_a?(Answer)
        patch :downvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
      else 
        patch :downvote, params: { id: model.id, format: :json }
      end

      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can vote down' do
      login(another_user)

      expect do
        if model.is_a?(Answer)
          patch :downvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
        else 
          patch :downvote, params: { id: model.id }, format: :json
        end
      end.to change(Vote, :count).by 1
      expect(model.rating).to eq(-1)
    end

    it "author's vote down for his own resource is not counted" do
      login(model.user)

      expect do
        if model.is_a?(Answer)
          patch :downvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
        else 
          patch :downvote, params: { id: model.id }, format: :json
        end
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end

  describe 'PATCH #resetvote' do
    it 'sends json response' do
      login(another_user)
      if model.is_a?(Answer)
        patch :upvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
      else 
        patch :upvote, params: { id: model.id }, format: :json
      end
      expect(model.rating).to eq(1)
      if model.is_a?(Answer)
        patch :resetvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
      else 
        patch :resetvote, params: { id: model.id, format: :json }
      end
      expect(response.header['Content-Type']).to include 'application/json'
      expect(JSON.parse(response.body)['rating']).to eq(model.reload.rating)
    end

    it 'user can cancel his up vote' do
      login(another_user)
      if model.is_a?(Answer)
        patch :resetvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
      else
        patch :resetvote, params: { id: model.id }, format: :json
      end

      expect do
        if model.is_a?(Answer)
          (patch :resetvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json) 
        else
          (patch :resetvote, params: { id: model.id }, format: :json)
        end
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end

    it 'author of resource can not cancel the vote' do
      login(model.user)
      if model.is_a?(Answer)
        patch :upvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json 
      else
        patch :upvote, params: { id: model.id }, format: :json
      end

      expect do
        if model.is_a?(Answer)
          (patch :resetvote, params: { id: model.id, question_id: "#{model.question.id}"}, format: :json )
        else
          (patch :resetvote, params: { id: model.id }, format: :json)
        end
      end.to_not change(Vote, :count)
      expect(model.rating).to eq(0)
    end
  end
end