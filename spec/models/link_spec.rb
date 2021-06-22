require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://google.com').for(:url) }
  it { should_not allow_value('foo').for(:url) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:link) { build(:link, name: 'First', url: 'https://gist.github.com/secretpray/4eb63d367dfb0553aa96da4b3f34c8a4', linkable: question) }
  let(:link1) { build(:link, name: 'Second', url: 'https://google.ru', linkable: question) }

  it '#gist?' do
    expect(link).to be_gist
    expect(link1).to_not be_gist
  end

  it 'must be in the right order' do
    [link, link1].each(&:save)

    expect(Link.all).to eq([link, link1])
  end
end
