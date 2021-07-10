require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one :reward }
  it { accept_nested_attributes_for :links }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it "is not valid without attributes" do
    expect(Question.new).to_not be_valid
  end

  describe "Associations" do
    it 'can have answers without validating presence' do
      should have_many(:answers).without_validating_presence
    end

    it 'can have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end
end
