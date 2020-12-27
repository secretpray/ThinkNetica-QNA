Rails.application.routes.draw do
  root 'questions#index'

  resources :questions do
    resources :answers, except: %i(index show)
  end
end
