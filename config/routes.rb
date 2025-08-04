Rails.application.routes.draw do

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               passwords: 'users/passwords'
             }

  namespace :api do
    namespace :v1 do
      resources :deposits, only: [:create, :show, :index]
      post '/webhooks/pix_confirmation', to: 'webhooks#pix_confirmation'
      resources :referrals, only: [:index]
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
