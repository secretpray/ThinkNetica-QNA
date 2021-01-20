require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :update?, :edit?, :destroy? do
    it "Deny access edit/update/destroy question not to the author of the question" do
      # expect(subject).not_to permit(create(:user), Question.new())
      expect(subject).not_to permit(create(:user), create(:question))
    end

    it "grants access if user is an admin" do
      expect(subject).to permit(create(:user, :admin), create(:question))
    end

    it "grants access to edit/update/destroy question to the author of the question" do
      expect(subject).to permit(create(:user), create(:question, user_id: User.last.id))
    end
  end
end
