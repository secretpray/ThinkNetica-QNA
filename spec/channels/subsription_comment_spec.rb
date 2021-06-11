require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  before { stub_connection user_id: user.id }

  it 'subscribes to CommentsChannel' do
    subscribe
    expect(subscription).to be_confirmed
  end

  it 'subscribes to a comment stream when question is provided' do
    subscribe(question_id: question.id)
    expect(subscription).to be_confirmed
    # check particular stream by name
    expect(subscription).to have_stream_from("questions/#{question.id}/comments")
    # or directly by model if you create streams with `stream_for`
    expect(subscription).to have_stream_for("questions/#{question.id}/comments")
  end
end
