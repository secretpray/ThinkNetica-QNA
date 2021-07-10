require 'rails_helper'

RSpec.describe AnswerNewNotificationJob, type: :job do
  let(:service) { double('AnswerNotificationService') }
  let(:answer) { create :answer }

  before do
    allow(AnswerNotificationService).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotificationService#send_notice' do
    expect(service).to receive(:send_notice)
    AnswerNewNotificationJob.perform_now(answer)
  end
end
