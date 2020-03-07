Rails.application.routes.draw do
  resources :widgets

  root 'welcome#index'

  # for LINE webhook
  post '/callback' => 'line_webhook#callback'
end
