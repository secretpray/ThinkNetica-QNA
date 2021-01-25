require 'rails_helper'

RSpec.describe AttachmentPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :destroy? do
    it "Deny access to destroy attachment not to the author of the attachment.record(question/answer)" do
      expect(subject).not_to permit(create(:user), create(:question))
      expect(subject).not_to permit(create(:user), create(:answer))
    end

    it "grants access to destroy attachment if user is an admin" do
      expect(subject).to permit(create(:user, :admin), create(:question))
    end

    it "grants access to destroy attachment to the author of the attachment.record(question/answer)" do
      expect(subject).to permit(create(:user), create(:question, user_id: User.last.id))
      expect(subject).to permit(create(:user), create(:answer, user_id: User.last.id))
    end
  end
end
