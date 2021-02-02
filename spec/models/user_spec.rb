require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it "is not valid without attributes" do
    expect(User.new).to_not be_valid
  end

  describe "Associations" do
    it {should have_many(:questions).dependent(:destroy)}
    it {should have_many(:answers).dependent(:destroy)}
    it { should have_many(:questions).without_validating_presence }
    it { should have_many(:answers).without_validating_presence }
  end
end
