Rails.application.routes.draw do

  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, except: %i(index, show)
  end
end
