require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }

  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Comment.new).to_not be_valid
  end

  describe "Associations" do
    it 'should belong_to user without validating presence' do
      should belong_to(:user).without_validating_presence
    end

    it "has a polymorphic relationship" do
      expect(subject).to belong_to(:commentable)
    end
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment) { create(:comment, commentable: question, user: user) }
  let(:comment1) { create(:comment, commentable: question, user: user) }

  it 'must be in the right order' do
    expect(Comment.all).to eq([comment, comment1])
  end
end
