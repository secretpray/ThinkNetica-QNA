Rails.application.routes.draw do

  devise_for :users

  resources :questions do
    resources :answers, except: %i(index, show) do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: [:destroy]
  
  root 'questions#index'

end
