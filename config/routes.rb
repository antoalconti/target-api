Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    sessions: 'api/v1/sessions'
  }

  namespace :api do
    namespace :v1 do
      resources :targets, only: %i[create show]
    end
  end
end
