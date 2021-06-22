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
end