Rails.application.routes.draw do

  root 'questions#index'

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
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
