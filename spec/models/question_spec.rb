require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Question.new).to_not be_valid
  end

  describe "Associations" do
    it { should have_many(:answers).without_validating_presence }
  end

end
