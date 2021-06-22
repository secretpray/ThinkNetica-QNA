require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }
  before { stub_connection user_id: user.id }

  it 'subscribes to QuestionsChannel' do
    subscribe
    expect(subscription).to be_confirmed
  end

  it 'check streaming questions_channel' do
    subscribe
    expect(subscription).to have_stream_from('questions_channel')
  end
end
