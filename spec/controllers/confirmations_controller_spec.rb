require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  include Capybara::Email::DSL

  let(:user) { create(:user) }
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'POST #create' do
    it 'assigns user as @user' do
      post :create, params: { user: attributes_for(:user, email: 'new@email.com'), user_id: user }

      expect(assigns(:user)).to eq user
    end

    it 'update on real user email' do
      post :create, params: { user: attributes_for(:user, email: 'new@email.com'), user_id: user }

      expect(assigns(:user).email).to eq 'new@email.com'
    end

    it 'send confirmation instruction' do
      expect do
        post :create, params: { user: attributes_for(:user, email: 'new@email.com'), user_id: user }
      end.to change(ActionMailer::Base.deliveries, :count).by(1)

      open_email('new@email.com')
      expect(current_email).to have_content 'Confirm my account'
    end

    it 'redirect to root path' do
      post :create, params: { user: attributes_for(:user, email: 'new@email.com'), user_id: user }

      expect(response).to redirect_to root_path
    end

    it 'can not update with empty email' do
      post :create, params: { user: attributes_for(:user, email: ''), user_id: user }

      expect(response).to render_template 'confirmations/email'
    end

    describe 'send confirmation when user already exists' do
      it 'update with same email' do
        post :create, params: { user: attributes_for(:user), user_id: user }

        expect(response).to redirect_to root_path
        expect(controller).to set_flash[:alert].to(/Please confirm your email/)
      end

      it 're-send confirmation instruction' do
        expect do
          post :create, params: { user: attributes_for(:user), user_id: user }
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        email = ActionMailer::Base.deliveries.last.body

        expect(email).to match /#{assigns(:user).email}/
        expect(email).to match /You can confirm your account email through the link below/
      end
    end
  end
end
