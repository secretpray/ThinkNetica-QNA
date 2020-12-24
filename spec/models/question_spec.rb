require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Question.new).to_not be_valid
  end

  describe "Uniqueness of title" do
    before do
      # @question = Question.new(title: "Is Ruby..?", body: "Is Ruby an interpreted programming language?")
      @question = FactoryBot.create(:question, title: "Is Ruby..?", body: "Is Ruby an interpreted programming language?")
    end

    describe "When question title is not unique" do
      before do
        question_with_same_title = @question.dup
        question_with_same_title.save
      end

      it { should_not be_valid }

    end
  end

  describe "Associations" do
    it { should have_many(:answers).without_validating_presence }
  end

end
