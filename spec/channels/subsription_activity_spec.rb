require 'rails_helper'

RSpec.describe ActivityChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  before do
    stub_connection user_id: user.id
    redis = Redis.new
    redis.set "online", "user.id"
    # Redis.stub(:new).and_return { redis_instance }
    # Redis::Store.stub(:new).and_return { redis_instance }
  end

  it 'subscribes to ActivityChannel' do
    subscribe
    expect(subscription).to be_confirmed
  end

  it 'subscribes to a activity user stream when question is provided' do
    subscribe(question_id: question.id)
    expect(subscription).to be_confirmed
    # check particular stream by name
    expect(subscription).to have_stream_from("activity_channel-#{question.id}")
    # or directly by model if you create streams with `stream_for`
    expect(subscription).to have_stream_for("activity_channel-#{question.id}")
  end
end
