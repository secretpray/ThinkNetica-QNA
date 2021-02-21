Rails.application.routes.draw do

  root 'questions#index'
  
  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :resetvote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, except: %i(index, show) do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
