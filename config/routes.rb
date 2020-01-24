Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions',
    passwords: 'api/v1/passwords'
  }
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :targets, only: %i[create show index destroy new]
      resources :chats, only: %i[show index]
      resources :site_infos, only: %i[] do
        get :info, on: :collection
      end
    end
  end
end
