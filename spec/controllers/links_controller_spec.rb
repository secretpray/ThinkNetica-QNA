require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_link, user: user) }

    before { login(user) }

    it 'delete link' do
      expect do
        delete :destroy, params: {id: question.links.first}, format: :js
      end.to change(Link, :count).by(-1)
    end

    it 'render view delete' do
      delete :destroy, params: {id: question.links.first}, format: :js
      expect(response).to render_template :destroy
    end
  end
end