require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:reward) { create(:reward, question: question, user: user) }

  before do
    sign_in(user)
    get :index
  end
  describe "GET #index" do
    it "assigns award to @rewards" do
      get :index
      expect(assigns(:rewards)).to eq user.rewards
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end
end