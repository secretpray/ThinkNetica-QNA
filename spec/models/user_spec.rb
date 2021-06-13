require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it "is not valid without attributes" do
    expect(User.new).to_not be_valid
  end

  describe "Associations" do
    it { should have_many(:authorizations).dependent(:destroy) }
    it {should have_many(:questions).dependent(:destroy)}
    it {should have_many(:comments).dependent(:destroy)}
    it {should have_many(:answers).dependent(:destroy)}
    it {should have_many(:rewards).dependent(:destroy)}
    it {should have_many(:votes).dependent(:destroy)}
    it { should have_many(:questions).without_validating_presence }
    it { should have_many(:answers).without_validating_presence }
    it { should validate_presence_of :email }
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
