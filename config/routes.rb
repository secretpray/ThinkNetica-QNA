require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper # /oauth/applications

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :resetvote
    end
  end

  concern :commentable do
    post :create_comment, on: :member
    delete :delete_comment, on: :member
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable], except: :index do
      patch :best, on: :member
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
        get :other, on: :collection
      end

      resources  :questions, except: %i[new edit], shallow: true do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  # get 'searches/index'
  resources :searches, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  root 'questions#index'
end
