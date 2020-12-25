require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Answer.new).to_not be_valid
  end

  describe "Associations" do
    it { should belong_to(:question).without_validating_presence }
  end

end
