Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace :api do
    namespace :v1 do
      resources :deposits, only: [:create, :show]
      post '/webhooks/pix_confirmation', to: 'webhooks#pix_confirmation'
      resource :profile, only: [:show, :update], controller: 'profile'
      resources :scratch_cards, only: [:index]
      resources :games, only: [:create, :index] do
        member do
          post :reveal
        end
      end
    end
  end
end
