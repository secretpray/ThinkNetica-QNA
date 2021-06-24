require 'rails_helper'

RSpec.describe CommentPolicy do
  context "permissions" do
    subject { described_class }
    let(:user) { User.new }

    permissions :delete_comment?, :delete? do
      it "deny access destroy comment not to the author of the comment" do
        expect(subject).not_to permit(create(:user), create(:comment, commentable: create(:question, user_id: User.last.id), user: create(:user)))
        expect(subject).not_to permit(create(:user), create(:comment, commentable: create(:answer, user_id: User.last.id), user: create(:user)))
      end

      it "grants access if user is an admin" do
        expect(subject).to permit(create(:user, :admin), create(:comment, commentable: create(:question, user_id: create(:user).id), user: User.last))
        expect(subject).to permit(create(:user, :admin), create(:comment, commentable: create(:answer, user_id: create(:user).id), user: User.last))
      end

      it "grants access to destroy comment to the author of the comment" do
        expect(subject).to permit(create(:user), create(:comment, commentable: create(:question, user_id: User.last.id), user: User.last))
        expect(subject).to permit(create(:user), create(:comment, commentable: create(:question, user_id: User.last.id), user: User.last))
      end
    end
  end
end
