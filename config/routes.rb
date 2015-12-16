Rails.application.routes.draw do
  devise_for :merchant

   namespace :v1, defaults: { format: :json } do
    resource :login, only: [:create], controller: :sessions
  end

end
