require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234') }
  let(:auth1) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '45678') }

  describe 'GitHub' do
    subject { FindForOauthService.new(auth) }

    context 'user already has authorization' do
      let!(:authorization) { create(:authorization, provider: 'github', uid: '1234', user_id: user.id) }

      it 'returns the user' do
        expect(subject.call).to eq user
      end

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'does not create authorization for user' do
        expect { subject.call }.to_not change(Authorization, :count)
      end
    end

    context 'user has not authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234', info: { email: user.email }) }

      context 'user already exist' do
        it 'does not create new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'create authorization for user' do
          expect { subject.call }.to change(Authorization, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = subject.call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(subject.call).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234', info: { email: 'newuser@email.com' }) }

        it 'creates new user' do
          expect { subject.call }.to change(User, :count).by(1)
        end

        it 'returns the user' do
          expect(subject.call).to be_a(User)
        end

        it 'fill user email' do
          user = subject .call
          expect(user.email).to eq auth.info[:email]
        end

        it 'create authorization for user' do
          expect { subject.call }.to change(Authorization, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = subject.call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe 'Facebook' do
    let!(:user1) { create(:user, email: 'uid_45678@facebook.com') }
    subject { FindForOauthService.new(auth1) }

    context 'user already has authorization' do
      it 'returns the user' do
        user1.authorizations.create(provider: 'facebook', uid: '45678')
        expect(subject.call).to eq user1
      end
    end

    context 'user has not authorization' do
      let(:auth1) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '45678', info: { email: '' }) }

      context 'user already exist' do
        it 'does not create new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'create authorization for user' do
          expect { subject.call }.to change(Authorization, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = subject.call.authorizations.first

          expect(authorization.provider).to eq auth1.provider
          expect(authorization.uid).to eq auth1.uid
        end

        it 'returns the user' do
          expect(subject.call).to eq user1
        end
      end

      context 'user does not exist' do
        let(:auth1) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '456789', info: { email: '' }) }

        it 'creates new user' do
          expect { subject.call }.to change(User, :count).by(1)
        end

        it 'returns the user' do
          expect(subject.call).to be_a(User)
        end

        it 'fill user email' do
          user = subject.call
          expect(user.email).to eq 'uid_456789@facebook.com'
        end

        it 'create authorization for user' do
          expect { subject.call }.to change(Authorization, :count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = subject.call.authorizations.first

          expect(authorization.provider).to eq auth1.provider
          expect(authorization.uid).to eq auth1.uid
        end
      end
    end
  end
end
