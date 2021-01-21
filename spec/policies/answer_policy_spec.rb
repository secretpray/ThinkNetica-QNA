require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :update?, :edit?, :destroy? do
    it "Deny access edit/update/destroy answer not to the author of the answer" do
      expect(subject).not_to permit(create(:user), create(:answer))
    end

    it "grants access if user is an admin" do
      expect(subject).to permit(create(:user, :admin), create(:answer, user_id: User.last.id + 1))
    end

    it "grants access to edit/update/destroy answer to the author of the answer" do
      expect(subject).to permit(create(:user), create(:answer, user_id: User.last.id))
    end
  end
end
