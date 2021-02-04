require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Answer.new).to_not be_valid
  end
  it { accept_nested_attributes_for :links }

  let(:user) {create(:user)}
  let!(:question) {create(:question, user: user)}
  let!(:answers) {create_list(:answer, 4, question: question, user: user)}

  it "should set first answer as best" do
    answer = question.answers.first
    answer.set_best
    expect(answer).to be_best
  end

  it "should set second answer to best and first answer to not be best" do
    second_answer = question.answers.second
    second_answer.set_best
    question.reload # reorder second (best) -> first

    expect(question.answers.first).to be_best
    expect(question.answers.second).to_not be_best
    expect(question.answers.last).to_not be_best
  end

  describe "Associations" do
    it 'should belong_to question without validating presence' do
      should belong_to(:question).without_validating_presence
    end

    it 'can have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
