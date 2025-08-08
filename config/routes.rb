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
      namespace :admin do
        resource :dashboard, only: [:show], controller: 'dashboards'
        resources :users, only: [:index, :show]
        resources :games, only: [:index, :show]
        resources :deposits, only: [:index, :show]
        resources :withdrawals, only: [:index, :show]
        resources :bonus_codes
        resources :scratch_cards
        resources :tickets, only: [:index, :show], param: :ticket_number do
          member do
            post :reply, to: 'tickets#create_reply'
          end
        end
      end
      resources :tickets, only: [:index, :show, :create], param: :ticket_number do
        member do
          post :reply, to: 'tickets#create_reply'
        end
      end
      resources :deposits, only: [:create, :show, :index]
      post '/webhooks/pix_confirmation', to: 'webhooks#pix_confirmation'
      resources :referrals, only: [:index]
      resource :profile, only: [:show, :update], controller: 'profile'
      resources :scratch_cards, only: [:index]
      resources :withdrawals, only: [:create, :index]
      resources :rankings, only: [:index]
      resources :games, only: [:create, :index, :show] do
        member do
          post :reveal
        end
        collection do
          post :play_free_daily
        end
      end
    end
  end
end
