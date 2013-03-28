Donationparty::Application.routes.draw do
  scope "/admin" do
    resources :charities
    resources :rounds
  end

  get '/round/:url' => 'rounds#display'
  post '/round/:url' => 'rounds#set_charity'
  get '/round_status/:url' => 'rounds#status'
  post '/update_address/' => 'rounds#update_address'

  post '/donation/create' => 'donations#create'

  get "home/index"

  root :to => "home#index"
end
